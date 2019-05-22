#include <stdbool.h>
#include <stdio.h>
#include "header.h"
#include <string.h>


void NewQueue(queue **head){
    (*head)=(queue*)malloc(sizeof(queue));
    (*head)->next=NULL;
    return;
}

void IsQueueEmpty(queue **head){
    if((*head)->next==NULL)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void Enqueue(queue **head, struct Patient A) {

    int *tmp=*head;
    (*head)=(queue*)malloc(sizeof(queue));
    (*head)->next=tmp;
    (*head)->patient=A;
    return;
}

void Dequeue(queue **head){
    if((*head)->next==NULL){
        return -1;
    }
    queue *tail = *head;
    queue * tmp;
    while(tail->next!= NULL){
        tmp=tail;
        tail=tail->next;
    }
    free(tail);
    tail=tmp;
    tail->next=NULL;
}


void DeleteQueue(queue **head){
    queue *tail = *head;
    int *tmp;
    while (tail->next!= NULL) {
        tmp = tail->next;
        free(tail);
        tail = tmp;
    }
    *head=tail;
    return;
}
