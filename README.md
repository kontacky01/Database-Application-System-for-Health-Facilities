# Database-Application-System-for-Health-Facilities
Project Date: WINTER 2023
Project Description
This system builds on and extends the application developed in the warm-up project. It
adds some new functionalities and requires a Graphical User Interface to facilitate user
interaction with the system.
In the main project, you develop a database system, called Health Facility Employee Status
Tracking System (HFESTS). The HFESTS system help health care facilities to keep track
of their employees’ health status during the COVID-19 pandemic.
The system should maintain all the information about the employees of the facilities that
are related to the pandemic. Information includes infection(s) of every employee, date of
infection and nature of infection. Also, information about the vaccination of every
employee including for every vaccination, the vaccination date, the type of vaccination,
and the dose number of the vaccination. Also, the schedule of work of every employee is
maintained by the system. The information maintained by the system is used to help the
facilities to keep track of their employees’ health status to reduce the risk of contamination
between the employees of the facilities.
A facility could be a hospital, a CLSC, a clinic, a pharmacy, or a special installment. Each
facility could include name, address, city, province, postal-code, phone number, web
address, type (Hospital, CLSC, clinic, pharmacy, or special installment), capacity
(Maximum number of employees that the facility needs to operate. At any moment in time,
a facility cannot have employees working at the facility that exceeds the capacity. A new
employee cannot be assigned to a facility if the current total number of employees currently
working for the facility is equal to the capacity of the facility). A facility have one general
manager.
The application must maintain information about every employee working in each facility.
The information includes first-name, last-name, date of birth, Medicare card number,
telephone-number, address, city, province, postal-code, citizenship, and email address.
Every employee must be registered with the public health care system which means that
the Medicare card number cannot have null value. No two employees can have the same
Medicare card number. The role of every employee must be maintained by the system. The
role could be either a nurse, a doctor, a cashier, a pharmacist, a receptionist, an
administrative personnel, a security personnel, or a regular employee (include all other
tasks). A general manager is considered to be an administrative personnel.
An employee can work at many facilities at the same time. At the same time means even
on the same day but should be at least 1 hour time gap between two assignments. For every
employee, the start date and end date working at each facility must be maintained. If the
end date is null, it indicates that the employee is still working at the facility. An employee
can work at the same facility at different interval of times. For example, Roger Smith who
is a doctor could have worked at Hospital Maisonneuve Rosemont from Jan 15th, 2022, to
June 30th 2022, then worked at Hospital Maisonneuve Rosemont from Jan 7th 2023 to now.
The application must maintain information on whether the employee has been vaccinated
or not. For each vaccination the employee had, the system must maintain information about
the type of Vaccination is given and the dose number as well with the date and the facility
location of each dose given. The type of vaccinations could be Pfizer, Moderna,
AstraZeneca, Johnson & Johnson, etc. Also, the dose number could be 1, 2, or more. For
example: Alfred McDonald could have taken the first vaccination dose Pfizer on the 20th
of January 2021 at CLSC Montréal South, and the second vaccination dose Moderna on
the 25th of April 2022 at Olympic Stadium Montréal.
Also, the application must maintain information on whether the employee has been infected
or not, and if yes, what was the infection name and type, and on which date(s). The
infection type could be COVID-19, SARS-Cov-2 Variant, or could be other types.
The schedule of every employee at each facility is maintained by the system. For every
facility, and for every employee working in the facility, the schedule includes the date, the
start time, and the end. Start time cannot be greater than the end time. An employee cannot
be scheduled at two different conflicting times neither at the same facility nor at different
facilities. If an employee is scheduled for two different periods on the same day either at
the same facility or at different facilities, then at least on hour should be the duration
between the first schedule and the second one. The history of the schedules is maintained
by the system. A schedule of four weeks ahead of time is supported by the system. If a
nurse or a doctor is infected by COVID-19, then he/she cannot be scheduled to work for at
least two weeks from the date of infection. An employee cannot be scheduled if she/he is
not vaccinated, at least one vaccine for COVID-19 in the past six months prior to the date
of the new schedule.
If a doctor or a nurse gets infected by COVID-19, then the system should automatically
cancel all the assignments for the infected employee for two weeks from the date of
infection. Also, the system should send an email to inform/track all the doctors and nurses
who have been in contact by having the same schedule as the infected employee. Each
email should have as a subject “Warning” and as a body “One of your colleagues that you
have worked with in the past two weeks have been infected with COVID-19”.
On Sunday of every week, for every employee working in every facility, the system should
automatically send an email to every employee indicating the schedule of the employee in
the facility for the coming week. The subject of the email should include the facility name,
and the dates covered by the schedule. A subject example: “CLSC Outremont Schedule for
Monday 20-Feb-2023 to Sunday 26-Feb-2023”. The email body should include the facility
name, the address of the facility, the employee’s first-name, last-name, email address, and
details of the schedule for the coming week. Details include day of the week, start time and
end time. The body of the message should also include an entry for every day of the week
followed by the starting hour and end hour for that day. A message “No Assignment” is
displayed if the employee is not scheduled for that specific entry.
A log table is stored in the database that contains information of every email generated by
the system. The log includes date of the email, the sender of the email (name of the facility),
the receiver of the email, the subject of the email, and the first 80 characters of the body of
the email.
