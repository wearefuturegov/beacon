import consumer from "../channels/consumer";

const contactId = document.getElementById('contactId').textContent;
let currentPeople = [];
let interval = null;

const subscription = consumer.subscriptions.create({ channel: 'ContactChannel', id: contactId }, {
    connected() {
        // Calls `ContactChannel#appear(data)` on the server.
        interval = setInterval(() => { 
         this.perform("viewing", { user_email: getUserEmail(), contact_id: contactId });
        }, 3000);
        
    },
    received(data) {
        const person = currentPeople.find(p => p.name === data.userEmail);
        if (person == null) currentPeople.push({ name: data.userEmail, lastSeen: Date.now() });
        else person.lastSeen = Date.now();
        if (data.type === 'VIEW') {
            updateViewings();
        } else if (data.type === 'CHANGED') {
            currentPeople = [];
            updateEdits(data.userEmail);
            subscription.unsubscribe();
        }

    },
    disconnected() {
        clearInterval(interval);
        subscription.unsubscribe();
    }
});


const getUserEmail = () => {
    return document.getElementById('userEmail').textContent;
}

const updateEdits = (userEmail) => {
    const div = document.getElementById("concurrent-users");
    div.innerHTML = '';
    const ul = document.createElement("ul");
    div.appendChild(ul);
    ul.textContent = 'This record is out of date';
    const li = document.createElement("li");
    li.appendChild(document.createTextNode("Contact: " + userEmail + " for clarifications."));
    ul.appendChild(li);
}

const updateViewings = () => {
    currentPeople = currentPeople.filter(p => p.lastSeen > Date.now() - 4000);
    let otherPeople = currentPeople.filter(p => p.name !== getUserEmail());
    const div = document.getElementById("concurrent-users");

    // add warning title
    if (otherPeople.length > 0) {
        div.innerHTML = '';
        const ul = document.createElement("ul");
        
        div.appendChild(ul);
        ul.textContent = 'Somebody else is viewing this page, you may be unable to save changes';
        // add other users looking at this page
        otherPeople.forEach(p => {
                const li = document.createElement("li");
                li.appendChild(document.createTextNode(p.name));
                ul.appendChild(li);                
        })
        
    } else {
        div.innerHTML = '';
    }
}
