# DICTIONARY

Comprehensive documentation can be found on the [MARS Website](https://courses.missouristate.edu/kenvollmar/mars/help/MarsHelpIntro.html).

Added for ease of use when developing MIPS programs.

## Include
**.include : include multiple files**

```
.include "another_file.asm"
```

requirement: they must be in the same dir

---
## Macros
**.macro : basically functions, we will use these to make code readable and easier to develop, as the program gets larger and larger.**

for example, a simple macro that terminates the program:

```
.macro done     #macro called done
    li $v0, 10  #system terminate code 
    syscall     #request

.end_macro      #macro definition ends here

```

macros may also take registers or immediate vals as arguments (very similar to C) like such:
```
.macro printInt (%x)     #macro called printInt
    li $v0, 1            #read integer code
    add $a0, $zero, %x   #load integer value into an address register
    syscall              #request
.end_macro               #end macro define
```

given the macro name printInt, **both of the following** macro invocations are valid:
1. `printInt ($s0)`
2. `printInt 10`

## 