#include <stdbool.h>
#if defined (__cplusplus)
extern "C" {
#endif
struct Patient;
struct Patient
{
    int timeToHeal;
    int money;
    int nextSession;
    int PatientID;
};
 struct qnode{
        struct Patient patient;
        struct qnode *next;
};
typedef struct qnode queue;
void NewQueue(queue **);
void Enqueue(queue **, struct Patient A);
void Dequeue(queue **);
void IsQueueEmpty(queue **);
void DeleteQueue(queue **);
#if defined (__cplusplus)
}
#endif
