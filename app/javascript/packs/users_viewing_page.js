import consumer from "../channels/consumer";

const contactId = document.getElementById('contactId').textContent;
let interval = null;
let updateNames = null;
let currentPeople = [];

const subscription = consumer.subscriptions.create({ channel: 'ContactChannel', id: contactId }, {
    connected() {
      //  this.perform("viewing", { "contact_id": contactId });
        interval = setInterval(() => { this.perform("viewing", { "contact_id": contactId }) }, 3000);
        updateNames = setInterval(() => {
            const filterEmail = document.getElementById('filterEmail').textContent;
            currentPeople = currentPeople.filter(p => p.lastSeen > Date.now() - 4000).filter(p => p.name !== filterEmail);
            const div = document.getElementById("concurrent-users");

            // add warning title
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
            

        }, 3000);
    },
    received(data) {
        const person = currentPeople.find(p => p.name === data);
        if (person == null) currentPeople.push({ name: data, lastSeen: Date.now() });
        else person.lastSeen = Date.now();
    },
    disconnected() {
        clearInterval(interval);
    }
});

const cleanup = () => {
    console.log("cleanup");
    clearInterval(interval);
    subscription.unsubscribe();
};

addEventListener("beforeunload", cleanup);
addEventListener("turbolinks:before-render", cleanup); 
