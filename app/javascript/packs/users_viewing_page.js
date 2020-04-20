import consumer from "../channels/consumer";

const contactId = document.getElementById('contactId').textContent;
let currentPeople = [];

const subscription = consumer.subscriptions.create({ channel: 'ContactChannel', id: contactId }, {
    connected() {
        console.debug("connected: ", contactId);
        // Calls `ContactChannel#appear(data)` on the server.
        this.perform("appear", { user_email: getUserEmail(), contact_id: contactId })
    },
    received(data) {
        console.debug("received: ", data);
        const person = currentPeople.find(p => p.name === data.userEmail);
        if (person == null) currentPeople.push({ name: userEmail });
        else person.lastSeen = Date.now();
    },
    disconnected() {
    }
});


const getUserEmail = () => {
    return document.getElementById('userEmail').textContent;
}

const updateNames = () => {
    currentPeople = currentPeople.filter(p => p.name !== getUserEmail());
    const div = document.getElementById("concurrent-users");

    // add warning title
    console.debug("current people ", currentPeople);
    if (currentPeople.length > 0) {
        div.innerHTML = '';
        const ul = document.createElement("ul");
        
        div.appendChild(ul);
        ul.textContent = 'Somebody else is viewing this page, you may be unable to save changes';
        // add other users looking at this page
        currentPeople.forEach(p => {
                const li = document.createElement("li");
                li.appendChild(document.createTextNode(p.name));
                ul.appendChild(li);                
        })
        
    } else {
        div.innerHTML = '';
    }
}

