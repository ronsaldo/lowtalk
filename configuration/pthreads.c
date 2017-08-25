#include <stdio.h>
#include <pthread.h>

#define SIZEOF_IN_WORDS(typename) (int)((sizeof(typename) + sizeof(void*) - 1) / sizeof(void*))

#define TYPE_INFO(typename) \
    printf("Constant named: #%s value: (UIntPointer array: %d). \"sizeof(%s) = %d\"\n", #typename, (int)SIZEOF_IN_WORDS(typename), #typename, (int) sizeof(typename));

#define CONSTANT_INT(constName) \
    printf("Constant named: #%s type: LibC CInt value: %d.\n", #constName, (int)constName);

int main()
{
    TYPE_INFO(pthread_attr_t);
    TYPE_INFO(pthread_mutex_t);
    TYPE_INFO(pthread_mutexattr_t);
    TYPE_INFO(pthread_cond_t);
    TYPE_INFO(pthread_condattr_t);
    TYPE_INFO(pthread_rwlock_t);
    TYPE_INFO(pthread_rwlockattr_t);
    
    CONSTANT_INT(PTHREAD_MUTEX_NORMAL);
    CONSTANT_INT(PTHREAD_MUTEX_ERRORCHECK);
    CONSTANT_INT(PTHREAD_MUTEX_RECURSIVE);
    CONSTANT_INT(PTHREAD_MUTEX_DEFAULT);
    return 0;
}
