import consumer from "../channels/consumer";

document.contactSubscription = {

    subscription: null,

    currentPeople: [],

    getUserEmail: ()=> {
        return document.getElementById('userEmail').textContent;
    },

    updateEdits: (currentUserEmail, userEmail) => {
        const div = document.getElementById("concurrent-users");
        div.innerHTML = '';

        if (currentUserEmail != userEmail) {
            div.className = 'outdated';
            const ul = document.createElement("ul");
            div.appendChild(ul);
            ul.textContent = 'This record has been changed';
            const li = document.createElement("li");
            li.appendChild(document.createTextNode("Contact: " + userEmail + " for clarifications."));
            ul.appendChild(li);
            setTimeout(function () {
                div.innerHTML = '';
            }, 5000);
        }
    },

    updateViewings: (currentPeople, userEmail) => {
        currentPeople = currentPeople.filter(p => p.lastSeen > Date.now() - 4000);
        let otherPeople = currentPeople.filter(p => p.name !== userEmail);
        const div = document.getElementById("concurrent-users");

        // add warning title
        if (otherPeople.length > 0) {
            div.innerHTML = '';
            const ul = document.createElement("ul");

            div.appendChild(ul);
            ul.textContent = 'Somebody else is editing this record';
            // add other users looking at this page
            otherPeople.forEach(p => {
                const li = document.createElement("li");
                li.appendChild(document.createTextNode(p.name));
                ul.appendChild(li);
            })

        } else {
            div.innerHTML = '';
        }
    },

    start: function (contactId) {
        let getUserEmail = this.getUserEmail;
        let updateViewings = this.updateViewings;
        let updateEdits = this.updateEdits;
        let currentPeople = this.currentPeople;
        currentPeople = [];

        this.subscription = consumer.subscriptions.create({ channel: 'ContactChannel', id: contactId }, {
            connected() {
                // Calls `ContactChannel#appear(data)` on the server.
                document.intervalId = setInterval(() => {
                    this.perform("viewing", { user_email: getUserEmail(), contact_id: contactId });
                }, 3000);
            },
            received(data) {
                const person = currentPeople.find(p => p.name === data.userEmail);
                if (person == null) currentPeople.push({ name: data.userEmail, lastSeen: Date.now() });
                else person.lastSeen = Date.now();

                if (data.type === 'VIEW') {
                    updateViewings(currentPeople, getUserEmail());
                } else if (data.type === 'CHANGED') {
                    currentPeople = [];
                    updateEdits(getUserEmail(), data.userEmail);
                    clearInterval(document.intervalId);
                    this.unsubscribe();
                }

            },
            rejected() {
            },
            disconnected() {
                clearInterval(document.intervalId);
                this.unsubscribe();
            }
        });
    },

    stop: function () {
        clearInterval(document.intervalId);
        this.subscription.unsubscribe();
    }

};