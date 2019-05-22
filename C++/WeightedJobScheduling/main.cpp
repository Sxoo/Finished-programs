// TURIME N DARBŲ, KURIŲ ATLIKIMO TRUKMĖ ATITINKAMAI (T1, T2, ... , TN), BAIGIMO TERMINAI (D1, D2, ..., DN), JEI DARBAI NEATLIEKAMI LAIKU,
// BAUDA ATITINKAMAI (B1, B2, ..., BN), KOKIA EILES TVARKA ATLIKTI DARBUS, KAD BAUDA BŪTŲ MINIMALI?

// WEIGHTED (TIME, DEADLINE, PENALTY) JOB SCHEDULING PROBLEM SOLVING ALGORITHM

// Martynas Padarauskas 2 grupė


#include <fstream>
#include <vector>
#include <algorithm>
#include <iostream>
using namespace std;

struct Job
{
    int time;
    int deadline;
    int penalty;
    int start = deadline - time;
    bool operator() (Job i,Job j)
        {
         return (i.deadline<j.deadline);
         }
}job;

struct jobWithValue
{
    vector<Job> job;
    int value;
};

int findNotOverlapping(Job jobs[], int i)
{
    int left = 0, right = i-1;
    while (left <= right)
    {
        int mid = (left + right)/2;
        if (jobs[mid].deadline <= jobs[i].start)
        {
            if (jobs[mid+1].deadline <= jobs[i].start)
                left = mid+1;
            else
                return mid;
        }
        else
            right = mid-1;
    }
    return -1;
}

void findMinPenSequence(Job arr[], int n)
{
    sort(arr, arr+n, job);

    jobWithValue WV[n];
    WV[0].value = arr[0].penalty;
    WV[0].job.push_back(arr[0]);

    for (int i=1; i<n; i++)
    {
        int currValue = arr[i].penalty;
        int j = findNotOverlapping(arr, i);
        if (j != -1)
        {
            currValue += WV[j].value;
        }
        if (currValue > WV[i-1].value)
        {
            WV[i].value = currValue;
            if (j != -1)
            {
                WV[i].job = WV[j].job;
            }
            WV[i].job.push_back(arr[i]);
        }
        else
        {
            WV[i] = WV[i-1];
        }
    }
    cout<<"Job sequencing for minimum penalty: "<<endl;
    for (int i=0; i<WV[n-1].job.size(); i++)
    {
        Job j = WV[n-1].job[i];
        cout<<"("<<j.start<<", "<<j.deadline<<", "<<j.penalty<<")"<<endl;
    }
    cout<<"Penalty saved: "<<WV[n-1].value<<endl;
}
int main()
{
    ifstream fd ("input.txt");
    int n;
    fd>>n;
    Job arr[n];
    for (int i=0; i<n; i++)
    {
        fd>>arr[i].time>>arr[i].deadline>>arr[i].penalty;
        arr[i].start = arr[i].deadline - arr[i].time;
    }
    fd.close();
    //Job arr[] = { {1, 1, 50}, {1, 2, 60}, {1, 1, 30}, {1, 3, 40}, {2, 2, 40}, {1, 1, 900}, {5, 5, 900}};
    //int n = sizeof(arr)/sizeof(arr[0]);

    findMinPenSequence(arr, n);

    return 0;
}
