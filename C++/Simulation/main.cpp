//Therapy clinic simulation implementing Queue of a colleague




#include <iostream>
#include <stdlib.h>
#include <vector>
#include "header.h"

using namespace std;

struct Group
{
    bool newbies = true;
    int TherapistID;
    vector <Patient> allGroupPatients;

};

struct Therapist
{
    int TherapistID;
    bool workingToday[200] = {false};
    int money = 0;

};

void checkNewPatient (int &p1, int &newPatientCounter, vector <Patient> &curr, int dayOfTheMonth)
{
    if ((rand()%100+1) <= p1)
    {
        cout<<"A new patient came to the clinic today"<<endl;
        newPatientCounter++;
        Patient newPatient;
        newPatient.timeToHeal = rand()%20+1;
        newPatient.money = (rand()%500+1) + 250;
        newPatient.nextSession = dayOfTheMonth;
        newPatient.PatientID = newPatientCounter;
        curr.push_back(newPatient);
        if (newPatientCounter >=30)
        {
            p1 = p1-15;
        }
    }
    else
    {
        cout<<"No new patients today..."<<endl;
    }
}

bool rollSocialFactor (Patient A, int p2)
{
    if ((rand()%100+1) <= p2)
    {
        cout<<"Patient "<<A.PatientID<<" has a gene for social therapy!"<<endl;
        return true;
    }
    else
    {
        return false;
    }
}

void chooseOptimalWayToHeal (Patient A, int GrT, int InT, int GrK, int InK, vector <Patient> &in, queue **wait, int h, int p2)
{
    int tryGr;
    int tryIn;
    if (rollSocialFactor(A, p2) == true)
    {
        tryGr = (A.timeToHeal-((A.timeToHeal*h)/100)/GrT)*GrK;
        tryIn = (A.timeToHeal/InT)*InK;
    }
    else
    {
        tryIn = (A.timeToHeal/InT)*InK;
        tryGr = (A.timeToHeal/GrT)*GrK;
    }
    if (tryIn <= A.money || tryGr <= A.money)
    {
        if (tryIn <= tryGr)
        {
            cout<<"Optimal therapy choice for patient "<<A.PatientID<<" is individual therapy "<<endl;
            in.push_back(A);
        }
        else
        {
            cout<<"Optimal therapy choice for patient "<<A.PatientID<<" is group therapy "<<endl;
            Enqueue(wait, A);
        }
    }
    else
    {
        cout<<"The new patient does not have enough money for needed therapy..."<<endl;
    }
}

void checkNewIndividualTherapist (int &m, Patient P, vector <Therapist> &inT, int dayOfTheMonth, int d, int InT)
{
    bool check = false;
    if (inT.empty() == true)
    {
        m++;
        Therapist A;
        A.TherapistID = m;
        inT.push_back(A);
    }
    for (int i=0; i<inT.size(); i++)
    {
        Therapist current = inT[i];
        if (current.workingToday[dayOfTheMonth] == false)
        {
            while (P.timeToHeal > 0)
            {
                current.workingToday[P.nextSession] = true;
                P.nextSession = P.nextSession + d;
                P.timeToHeal = P.timeToHeal - InT;
                current.money = current.money + 55;
            }
            check = true;
        }
        inT[i] = current;
    }
    /*if (check == false)
    {
        cout<<"!!!!!We must hire an additional individual therapy specialist!!!!!"<<endl;
        m++;
        Therapist A;
        A.TherapistID = m;
        while (P.timeToHeal > 0)
        {
            A.workingToday[P.nextSession] = true;
            P.nextSession = P.nextSession+d;
            P.timeToHeal = P.timeToHeal - InT;
        }
        inT.push_back(A);
    }*/
}

void individualTherapy(int &m, vector <Patient> &inP, vector <Therapist> &inT, int d, int dayOfTheMonth, int InT)
{
    for (int i=0; i<inP.size(); i++)
    {
        Patient current = inP[i];
        if (current.timeToHeal > 0)
        {
            checkNewIndividualTherapist(m, current, inT, dayOfTheMonth, d, InT);
            current.nextSession=current.nextSession+d;
            current.timeToHeal=current.timeToHeal-InT;
            inP[i] = current;
        }
        else
        {
            cout<<"The clinic successfully healed patient "<<current.PatientID<<" via individual therapy!"<<endl;
            inP.erase(inP.begin()+i);
        }
    }
}

void checkNewGroupTherapist (int &n, Group &grP, vector <Therapist> &grT, int dayOfTheMonth, int d, int GrT)
{
    if (grT.empty() == true)
    {
        n++;
        Therapist A;
        A.TherapistID = n;
        grT.push_back(A);
    }
    bool check = false;
    for (int i=0; i<grT.size(); i++)
    {
        Therapist current = grT[i];
        if (current.workingToday[dayOfTheMonth] == false)
        {
            for (int j=0; j<grP.allGroupPatients.size(); j++)
            {
                Patient currently = grP.allGroupPatients[j];
                while (currently.timeToHeal > 0)
                {
                    current.workingToday[currently.nextSession] = true;
                    currently.nextSession = currently.nextSession + d;
                    currently.timeToHeal = currently.timeToHeal - GrT;
                    current.money = current.money + 25;
                }
            }
            check = true;
            grP.TherapistID = current.TherapistID;
            grT[i] = current;
        }
    }
    /*if (check == false)
    {
        cout<<"!!!!!We must hire an additional group therapy specialist!!!!!"<<endl;
        n++;
        Therapist A;
        A.TherapistID = n;
        for (int j=0; j<grP.allGroupPatients.size(); j++)
        {
            Patient currently = grP.allGroupPatients[j];
            while (currently.timeToHeal > 0)
            {
                A.workingToday[currently.nextSession] = true;
                currently.nextSession = currently.nextSession + d;
                currently.timeToHeal = currently.timeToHeal - GrT;
            }
        }
        grP.TherapistID = A.TherapistID;
        grT.push_back(A);
    }*/
}

void groupTherapy (int &n, vector <Group> &grP, vector <Therapist> &grT, int d,int k, int dayOfTheMonth, int GrT, queue **wait)
{
    int peopleWaiting=0;
    queue *tmp = *wait;
    while (tmp->next!=NULL)
    {
        tmp = tmp->next;
        peopleWaiting++;
    }
    DeleteQueue(&tmp);
    if (peopleWaiting>=k)
    {
        Group current;
        while ((*wait)->next!=NULL)
        {
            current.allGroupPatients.push_back((*wait)->patient);
            *wait = (*wait)->next;
        }
        checkNewGroupTherapist(n,current,grT,dayOfTheMonth,d,GrT);
        grP.push_back(current);
    }
    else
    {
        cout<<peopleWaiting<<" in queue for group therapy"<<endl;
    }
    for (int i=0; i<grP.size(); i++)
    {
        Group currentGroup = grP[i];
        for (int j=0; j<currentGroup.allGroupPatients.size(); j++)
        {
            Patient currentPatient = currentGroup.allGroupPatients[j];
            if (currentPatient.timeToHeal > 0)
            {
                currentPatient.timeToHeal = currentPatient.timeToHeal - GrT;
                currentPatient.nextSession = currentPatient.nextSession + d;
                currentGroup.allGroupPatients[j] = currentPatient;
            }
            else
            {
                cout<<"Patient under the wings of therapist: "<<currentGroup.TherapistID<<" is successfully healed - Patient ID "<<currentPatient.PatientID<<endl;
                currentGroup.allGroupPatients.erase(currentGroup.allGroupPatients.begin()+j);
            }
        }
        currentGroup.newbies = false;
        grP[i] = currentGroup;
    }
}

int main()
{
    // DATA
    int n = 1; // group therapy session specialists;
    int k = 3; // people in group therapy sessions needed;
    int GrT = 1; // group therapy session time;
    int m = 1; // individual specialists;
    int InT = 2; // individual therapy time;
    int p1 = 100; // new patient chance;
    int newPatientCounter = 0;
    int d = 6; // time for next therapy;
    int p2 = 20; // chance of social factor;
    int h = 15; // percentage of time saved if social factor = true;
    int InK = 55; // price of individual therapy;
    int GrK = 25; // price of group therapy;
    int dayOfTheMonth = 1;
    vector <Patient> newPatients;
    vector <Patient> individualPatients;
    vector <Group> groups;
    vector <Therapist> individualTherapists;
    vector <Therapist> groupTherapists;
    queue *waitLine;
    NewQueue(&waitLine);

    /*Therapist A;
    A.TherapistID = 1;
    individualTherapists.push_back(A);
    Therapist B;
    B.TherapistID = 2;
    individualTherapists.push_back(B);*/

    Therapist A;
    A.TherapistID = 1;
    groupTherapists.push_back(A);
    Therapist B;
    B.TherapistID = 2;
    individualTherapists.push_back(B);


    // SIMULATE

    while (dayOfTheMonth != 31)
    {
        cout<<"-----------------------------------------------------------------------------------------------"<<endl;
        cout<<"Day "<<dayOfTheMonth<<" of the Martynas Therapy clinic"<<endl;
        checkNewPatient(p1, newPatientCounter, newPatients, dayOfTheMonth);
        if (newPatients.empty() == false)
        {
            Patient currentPatient = newPatients.back();
            newPatients.pop_back();
            chooseOptimalWayToHeal(currentPatient, GrT, InT, GrK, InK, individualPatients, &waitLine, h, p2);
        }
        individualTherapy(m, individualPatients, individualTherapists, d, dayOfTheMonth, InT);
        cout<<endl;
        cout<<endl;
        groupTherapy (n, groups, groupTherapists, d,k, dayOfTheMonth, GrT, &waitLine);
        dayOfTheMonth++;
        cout<<"-----------------------------------------------------------------------------------------------"<<endl;
        cout<<endl;
        cout<<endl;
        cout<<endl;
    }
    DeleteQueue(&waitLine);
    cout<<"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"<<endl;
    cout<<"The therapy clinic went bankrupt, we will need to fire"<<endl;
    cout<<"Individual therapists: "<<m<<endl;
    cout<<"Group therapists: "<<n<<endl;
    cout<<"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"<<endl;
    cout<<endl;
    cout<<endl;
    cout<<endl;
    for (int i=0; i<individualTherapists.size(); i++)
    {
        Therapist A = individualTherapists[i];
        cout<<"Individual Therapist ID: "<<A.TherapistID<<" Money made: "<<A.money<<endl;
    }

    for (int i=0; i<groupTherapists.size(); i++)
    {
        Therapist A = groupTherapists[i];
        cout<<"Group Therapist ID: "<<A.TherapistID<<" Money made: "<<A.money<<endl;
    }

    cout<<endl;
    cout<<endl;
    cout<<endl;
}
