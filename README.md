# Code-Samples

### Axios

A Javascript service file to handle axios calls to a custom-built API. 

**User Stories**  
As a Provider, I want to write a note after a reservation to mark how the gig went on x-day. The form should have the names of all customers (Seekers) pre-populated in a drop down menu based on confirmed appointments. When I see all notes, I want the option to edit or delete the note, and I want to be able to search all notes by Seeker first + last names. When I edit a note, I want the form to pre-populate with text.

As a Seeker I want to see all the notes from past reservations. I want to search all notes by Provider first + last name. I should not have the option to edit nor delete notes.

### C#

Middle Tier built in Microsoft Visual Studio to service the Note feature based on User Stories above.

Includes:
* Domain Model
* Service Interface
* Service File
* API Controller

### React

Components built with ReactJS to hanlde the Note feature. 

Includes:
* Card Component
* Cards Component
* Form Component to write note utilizing Formik & Yup
* PDF download Component of feature (ask me about this as not my preferred UX)

### SQL

A sample of stored procedures that I created.

Includes:
* CRUD for a feature involving Venues
* Search with pagination for Notes feature
* Stored Procedures involving batch Insert/Update with a UDT to assign many skills to one friend


