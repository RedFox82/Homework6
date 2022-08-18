import {LightningElement} from 'lwc';

export default class ContactList extends LightningElement {
    contacts = [
        {
            Id: 3,
            FirstName: 'Leung',
            LastName: 'Chang',
            Position: 'Marketing Manager',
            Phone: '',
            Email: 'leung@gogetcloudy.com'
        },
        {
            Id: 2,
            FirstName: 'Carry',
            LastName: 'Chan',
            Position: 'Marketing Manager',
            Phone: '775-555-5309',
            Email: ''
        },
        {
            Id: 3,
            FirstName: 'Alan',
            LastName: 'Johnson',
            Position: 'Sales Manager',
            Phone: '(720) 444-1229',
            Email: 'alan@gogetcloudy.com'
        },
        {
            Id: 4,
            FirstName: 'Anna',
            LastName: 'Johns',
            Position: 'Trainee',
            Phone: '',
            Email: ''
        }
    ]

}