<p align="center">
    <a href="https://beacon-support-staging.herokuapp.com/">
        <img src="https://github.com/wearefuturegov/beacon/blob/master/app/assets/images/beacon.png?raw=true" width="350px" />               
    </a>
</p>
  
<p align="center">
    <em>Record and triage needs, get people the right support</em>         
</p>

---

# Acceptance Test Suite

The acceptance tests run with the following command
```
bundle exec cucumber
```

To run the acceptance tests in firefox, set the BROWSER environment variable and run
```
BROWSER=firefox bundle exec cucumber
```

To run the acceptance tests in chrome (via chromedriver),
 set the BROWSER environment variable and run
```
BROWSER=remote_chrome bundle exec cucumber
```
This requires https://chromedriver.chromium.org/ to be running locally 