
DYLAN DOWNARD
dylan.downard@stonybrook.edu
CSE390 SUMMER 2021
SBUID: 110150888

Final Project:
iOS Development
Office Hours App


Notes:
Developed on iPhone11. I would appreciate if it was used to view these screens.

I believe I went off the path of the "idea" of the Office Hours App a little bit, as each student is able to make an appointment with each professor concurrently, whereas the homework file states for it to be for 1 professor. I think it works better the way I have implemented it in today's world, as with Zoom, you don't have to sit outside a classroom to wait. You may be able to get into office hours with 1 professor before another, while waiting on multiple wait lists. This also allows professors to cancel appointments with more peace of mind, as they can assume the student may be in a different appointment.

"Table with customized cell." I didn't really see much more room to customize the cells in my table, so I gave the 3 Debug Tables ontop of the Queue for actual functionality. I hope this makes up for the cells not being as flashy as other apps may be (though all the information you'd need are on the cells as is)

I wasn't sure what "Proper Swift source documentation which also includes // Mark: directives." meant specifically, so hopefully the documentation that I have given is sufficient.

Throughout the app and documentation, some terms are interchangable. Such terms are: {Faculty, Professor, Teacher} and {Appointment, Ticket, Reservation}.

There is a debug screen implemented for you on the Login and User screens. They will allow you to modify and view the CoreData tables directly without having to use the app's functionality (although you cannot add to the data, only view and delete.)

And finally: I'm incredibly sure that I've went crazy overboard in how the views are managed/segued to each other. I've entirely circumvented the use of AppDelegate and SceneDelegate, and I'm pretty sure that it made this a ton more complicated than it needed to be. Sorry a ton for the masses of repeated code. It DOES work (for me, at least) and runs smooth enough (after the simulator warms up per run) so I didn't feel the need to go back and change everything over to work on delegate stuff (also taking CSE351 and ARS281, so this is how I allotted my time.) The only thing I really "regret" in the final product is that when a user presses the "add" AppBar button, an intermediate "ticketviewer" is shown for a second. This view figures out which view should actually load in. I didn't come up/research a better way to do this, though I feel like it's still acceptable for this level of project.

I don't know if there's feedback given on these projects (as I didn't get any for the homeworks [100 on HW1 so no feedback required, HW2 not graded yet]) but I'd really appreciate feedback of any kind, even if I score perfect (especially if I score a 0.) My student email is dylan.downard@stonybrook.edu, if you have time let me know what I could improve on or what features would've made more sense.


Thanks for grading/testing, have a nice summer afterwards!


Picture Explanations:
Ex1 : Login Screen. Used to login to both Students and Faculty.
Ex2 : Register Screen. Used to register both Students and Faculty.
Ex3 : Not Logged In Screen. Shown if you are not logged in and press either the "add" or "queue" AppBar buttons
Ex4 : User Screen. Displays your name, as well with your pending appointments and your ready appointments. You can logout from this screen.
Ex5 : From the User/Login screens, you can access a Debug screen. This screen allows you (the tester) to view all of the data from CoreData, and delete by swipe if need be. Keep in mind, this is for Debug purposes, and is not set up to fix the relationships between data if you delete certain items. If you attempt to swipe the logged-in user, it will tell you that the user is logged in, blocking you from deleting them.
Ex6 : When a Student is logged in and uses the "add" AppBar item, it will bring up a Make Appointment screen. This allows students to choose a professor they'd like to make an appointment with. If you already have a ticket with that professor, then you cannot make an appointment with them. This is considered a "pending" appointment.
Ex7 : The "Queue" button on the AppBar brings both students and faculty to the Queue screen. Here students are able to see all of their appointments with where they are in the queue for each, and professors are able to see their queues (pictured later.)
Ex8 : Sort Settings from the NavigationItem from Queue allows a user to define how their queue page is sorted.
Ex9 : The same student queue as Ex7, but now sorted by faculty's ID (though it is not pictured in the cells)
Ex10: The User screen, but logged in as a faculty.
Ex11: When a Faculty is logged in and pressed the "add" button on the AppBar, they are given a view of their first student's appointment in the queue. When the faculty presses the "Ready" button, it will change the status of the ticket to ready, so that the student can accept it in their queue screen.
Ex12: After a ticket is accepted, or if there is no ticket, a "waiting for ticket" label will pop up while a new ticket is located. If there are no new tickets, this screen will refresh every 5 seconds until there is one (for testing, there is no way to add a ticket for a user, so this is functionally an infinite wait)
Ex13: Back to a student's view: Eugene Stark has readied this student's ticket, so when they swipe the cell they are able to signify they will start the appointment. This will delete the ticket out of the queue, and by proxy, the ticket out of the cell.
Ex14: For a student, if the appointment is not in the ready status, swiping will allow you to cancel the appointment. This is the same functionality as the professors have in the queue screen.
