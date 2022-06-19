#include "types.h"
#include "stat.h"
#include "user.h"

#define NULL ((void *)0)

int
main()
{
    int deref;
    int *null_pointer;
    null_pointer = NULL;
    deref = *null_pointer;
    printf(1, "Value: %d\n", deref);
    printf(1, "NULL Pointer value: %p\n", *null_pointer);
    exit();
}