/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*      ScheduleToCheckEscalationStatus
*  @description This class runs in every 12 hours to check status of records which are in escalation
***********************************************************************/
global with sharing class ScheduleToCheckEscalationStatus implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
    }
}