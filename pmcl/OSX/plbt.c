/*
   Copyright (C) 1994-2001 Digitool, Inc
   This file is part of OpenMCL.  

   OpenMCL is licensed under the terms of the Lisp Lesser GNU Public
   License , known as the LLGPL and distributed with OpenMCL as the
   file "LICENSE".  The LLGPL consists of a preamble and the LGPL,
   which is distributed with OpenMCL as the file "LGPL".  Where these
   conflict, the preamble takes precedence.  

   OpenMCL is referenced in the preamble as the "LIBRARY."

   The LLGPL is also available online at
   http://opensource.franz.com/preamble.html
*/

#include "lisp.h"
#include "area.h"
#include "lisp-exceptions.h"
#include "lisp_globals.h"

/* More-or-less like c printf(); */
int Dprintf(const char *format, ...);


char *
print_lisp_object(LispObj);

#ifdef PMCL_OSX_NATIVE_KERNEL
#undef undefined
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>
#endif

typedef struct dl_info {
  const char      *dli_fname;     /* Pathname of shared object */
  void            *dli_fbase;     /* Base address of shared object */
  const char      *dli_sname;     /* Name of nearest symbol */
  void            *dli_saddr;     /* Address of nearest symbol */
} Dl_info;

int
our_dladdr(void *p, Dl_info *info)
{
  unsigned long i;
  unsigned long j;
  unsigned long count = _dyld_image_count();
  struct mach_header *mh = 0;
  struct load_command *lc = 0;
  unsigned long addr = 0;
  unsigned long table_off = (unsigned long)0;
  int found = 0;

  if (!info)
    return 0;
  info->dli_fname = 0;
  info->dli_fbase = 0;
  info->dli_sname = 0;
  info->dli_saddr = 0;
  /* Some of this was swiped from code posted by Douglas Davidson
   * <ddavidso AT apple DOT com> to darwin-development AT lists DOT
   * apple DOT com and slightly modified
   */
  for (i = 0; i < count; i++) {
    addr = (unsigned long)p - _dyld_get_image_vmaddr_slide(i);
    mh = (struct mach_header *)_dyld_get_image_header(i);
    if (mh) {
      lc = (struct load_command *)((char *)mh + sizeof(struct mach_header));
      for (j = 0; j < mh->ncmds; j++, lc = (struct load_command *)((char *)lc + lc->cmdsize)) {
	if (LC_SEGMENT == lc->cmd &&
	    addr >= ((struct segment_command *)lc)->vmaddr &&
	    addr <
	    ((struct segment_command *)lc)->vmaddr + ((struct segment_command *)lc)->vmsize) {
	  info->dli_fname = _dyld_get_image_name(i);
	  info->dli_fbase = (void *)mh;
	  found = 1;
	  break;
	}
      }
      if (found) {
	    break;
      }
    }
  }
  if (!found) {
    return 0;
  }
  lc = (struct load_command *)((char *)mh + sizeof(struct mach_header));
  for (j = 0; 
       j < mh->ncmds; 
       j++, lc = (struct load_command *)((char *)lc + lc->cmdsize)) {
    if (LC_SEGMENT == lc->cmd) {
      if (!strcmp(((struct segment_command *)lc)->segname, "__LINKEDIT"))
	break;
    }
  }
  table_off =
    ((unsigned long)((struct segment_command *)lc)->vmaddr) -
    ((unsigned long)((struct segment_command *)lc)->fileoff) + _dyld_get_image_vmaddr_slide(i);
  
  lc = (struct load_command *)((char *)mh + sizeof(struct mach_header));
  for (j = 0; 
       j < mh->ncmds; 
       j++, lc = (struct load_command *)((char *)lc + lc->cmdsize)) {
    if (LC_SYMTAB == lc->cmd) {
      struct nlist *symtable = (struct nlist *)(((struct symtab_command *)lc)->symoff + table_off);
      unsigned long numsyms = ((struct symtab_command *)lc)->nsyms;
      struct nlist *nearest = NULL;
      unsigned long diff = 0xffffffff;
      unsigned long strtable = (unsigned long)(((struct symtab_command *)lc)->stroff + table_off);
      for (i = 0; i < numsyms; i++) {
	/* fprintf(stderr,"%s : 0x%08x, 0x%x\n",(char *)(strtable + symtable->n_un.n_strx) ,symtable->n_value, symtable->n_type); */
	/* Ignore the following kinds of Symbols */
	if ((!symtable->n_value)	/* Undefined */
	    || (symtable->n_type & N_STAB)	/* Debug symbol */
	    || ((symtable->n_type & N_TYPE) != N_SECT)	/* Absolute, indirect, ... */
	    ) {
	  symtable++;
	  continue;
	}
	if ((addr >= symtable->n_value) && 
	    (diff >= addr - (symtable->n_value ))) {
	  diff = addr- (unsigned long)symtable->n_value;
	  nearest = symtable;
	}
	symtable++;
      }
      if (nearest) {
	info->dli_saddr = nearest->n_value + ((void *)p - addr);
	info->dli_sname = (char *)(strtable + nearest->n_un.n_strx);
      }
    }
  }
  return 1;
}



Boolean
emulated_frame_p(lisp_frame *frame)
{
  return ((((int) (frame->backlink)) & 1) != 0);
}


Boolean
lisp_frame_p(lisp_frame *spPtr)
{
  LispObj savefn;
  if (((lisp_frame *) spPtr->backlink) != (spPtr+1)) {
    return false;
  }
  return true;
}


void
print_lisp_frame(lisp_frame *frame)
{
  LispObj fun = frame->savefn, pc = frame->savelr;
  int delta = 0;
  Dl_info info;
  char *spname;

  if ((fun == 0) || (fun == fulltag_misc)) {
    spname = "unknown ?";
    if (our_dladdr((void *)pc, &info)) {
      spname = (char *)(info.dli_sname);
    }
    Dprintf("(#x%08X) #x%08X : (subprimitive %s)", frame, pc, spname);
  } else {
    if ((fulltag_of(fun) != fulltag_misc) ||
        (header_subtag(header_of(fun)) != subtag_function)) {
      Dprintf("(#x%08X) #x%08X : (not a function!)", frame, pc);
    } else {
      LispObj code_vector = deref(fun, 1);
      
      if ((pc >= (code_vector+misc_data_offset)) &&
          (pc < ((code_vector+misc_data_offset)+(header_element_count(header_of(code_vector))<<2)))) {
        delta = (pc - (code_vector+misc_data_offset));
      }
      Dprintf("(#x%08X) #x%08X : %s + %d", frame, pc, print_lisp_object(fun), delta);
    }
  }
}


void
print_foreign_frame(void *frame)
{
  long pc = (long) (((c_frame *)frame)->savelr);

  Dl_info foreign_info;

  if (our_dladdr((void *)pc, &foreign_info)) {
    Dprintf("(#x%08x) #x%08X : %s + %d", frame, pc, foreign_info.dli_sname,
	    pc-((int)foreign_info.dli_saddr));
  } else {
    Dprintf("(#x%08X) #x%08X : foreign code (%s)", frame, pc, "unknown");
  }

}


/* Walk frames from "start" to "end".  Give up if an emulated frame is
   encountered.  Say whatever can be said about foreign frames and
   lisp frames.
*/

void
walk_stack_frames(lisp_frame *start, lisp_frame *end) 
{
  lisp_frame *next;
  Dprintf("\n");
  while (start < end) {
    if (emulated_frame_p(start)) {
      break;
    }

    if (lisp_frame_p(start)) {
      print_lisp_frame(start);
    } else {
      print_foreign_frame((c_frame *)start);

    }
    
    next = start->backlink;
    if (next == 0) {
      next = end;
    }
    if (next < start) {
      fprintf(stderr, "Bad frame! (%x < %x)\n", next, start);
      break;
    }
    start = next;
  }
}

void
walk_other_areas()
{
  area *a = ((area *) lisp_global(ALL_AREAS))->succ, *walked = (area *) (lisp_global(CURRENT_CS));
  area_code code;

  while ((code = a->code) != AREA_VOID) {
    if (code == AREA_CSTACK) {
      if (a != walked) {
        Dprintf("\n\ncstack area #x%08x", a);
        walk_stack_frames((lisp_frame *) (a->active), (lisp_frame *) (a->high));
      }
    }
    a = a->succ;
  }
}

void
plbt_sp(LispObj currentSP)
{
  area *cs_area;
  
  if (lisp_nil == (LispObj) NULL) {
    fprintf(stderr, "can't find lisp NIL; lisp process not active process ?\n");
  } else {
    cs_area = (area *) (lisp_global(CURRENT_CS));
    if ((((LispObj) (cs_area->low)) > currentSP) ||
        (((LispObj) (cs_area->high)) < currentSP)) {
      Dprintf("\nStack pointer [#x%08X] in unknown area.", currentSP);
    } else {
      walk_stack_frames((lisp_frame *) currentSP, (lisp_frame *) (cs_area->high));
      walk_other_areas();
    }
  }
}

  
void
plbt(ExceptionInformation *xp)
{
  plbt_sp(xpGPR(xp, sp));
}
    
const char *
foreign_name_and_offset(void *frame, unsigned *delta)
{
  Dl_info info;
  void *pc = (void *) (((c_frame *)frame)->savelr);
  if (our_dladdr(pc, &info)) {
    if (delta) {
      *delta = (unsigned)pc - (unsigned)info.dli_saddr;
    }
    return info.dli_sname;
  }
  if (delta) {
    *delta = 0;
  }
  return NULL;
}
