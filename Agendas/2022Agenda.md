# Community Support Office Hours - 2022 Agenda

## November 9 - Backend Squad

**Community Forum Posts**

**Dicussion Item #1**

We would like to learn and discuss about the frequent issues occurs with the Image Rendering while doing an update or upgrade either in a local or containerized environment

- https://community.grafana.com/t/certificate-error-with-renderer-docker-image-and-https/74948/9

**Summary**: 

In the above case, the user reports an issue that the SSL certificates are not working after performing an update. Checking the logs seems to indicate an issue with the handshake while calling the remote rendering engine.

We have already suggest some of the ENV Variables to the customer from previous posts and issues but it does help him.

**Discussion**: 

The backend squad noticed that the docker compose file had the GF_RENDERING_IGNORE_HTTPS_ERRORS=true environment variable settings applied for the grafana container but not for the image renderer one. They suggested to try moving those settings to the renderer section. 

**Dicussion Item #2**

We would like to discuss and understand better as how to do the import and export of Dashboards correctly.

- https://community.grafana.com/t/how-to-import-export-dashboards-from-a-enviroment-to-another/60600


**Summary**: 

We see many post (even got asked questions internally) that importing/exporting a Dashboard via JSON does not get the exact same dashboard as expected (even the Datasource is correctly configured).

The commom sceanrios are for e.g.

- Importing / Exporting dashboard from one Grafana server to Another (running same versions)
- Importing / Exporting dashboard from one Grafana server to Another (running different versions)
- Importing / Exporting dashboard from one Grafana server to Another (same version but different env. e.g. local to containerized / vice-versa)
- Importing / Exporting dashboard from one Grafana server to Another (from Grafana OSS to Enterprise or Cloud / vice-versa)



**Discussion**: 

Current options for duplicating environments are provisioning, API scripts like the one in the post, or the grizzly tool. Long-term the as-code squad will be working on other ways to accomplish this. 

Note that provisioned dashboard edits are only stored local to the grafana instance in the database and are not sync'd across environments. 

When editing JSON in dashboards or panels, the elements are not ordered. This is expected because of the way that javascript works. They recommended using `jq` to help working with JSON. There is a potential future project that would involve creating a schema for dashboards to make the format more predictable and to inform the database about the structure and potentially improve error messages. 

**What Backend would to know more from Community Support Squad**

What Backend Team like to learn, see, feeback in the community from us?

  - They are interested to hear more about API use cases - we'll try to gather more information about that for future sessions. 

Upcoming changes in Grafana 10 we should know about?
  - Often there are backend changes that aren't visible to users but would be helpful for community support to understand if related issues show up in forum or triage issues

Share some ideas (Brainstroming):
 - Trying out sample processes or specific how-to in the forum. For example, how to back up the sqlite database or how to upgrade between multiple major versions. 


## June 22 - User-essentials Squad 

**Community Forum Posts**

We'd love to understand more about how data links work, these are two examples of the types of questions we see: 

- https://community.grafana.com/t/data-link-not-working-properly/67160
  
    **Summary**: 

    I’m trying to use a data link to populate a different panel with a template variable. The template variable name is interface. I configured the data link in the following way.

    http://vlah.com:3000/d/BxN80iWnz/router-dashboard?orgId=1&var-interface=${__series.name}

    When I click on the data link, however, it populates the interface value with the name of the measurement in the query.

    **Discussion**: 
    
We walked through some steps on play.grafana.org to see how to isolate variables that we want to use in the data links. For example, the URL will have the variables listed: https://play.grafana.org/d/bIIJVo8nk/datalink-with-all_variables-and-time-range?orgId=1&var-app=fakesite&var-server=All&var-interval=1h&editPanel=1 we can use the URL try out different values to see the result in the dashboard.

   - https://community.grafana.com/t/how-to-build-a-data-link-to-filter-current-dashboard-when-there-is-more-than-one-variable/60220/2 

    **Summary**:
  
  One pie chart TransactionType with the data link with TransactionType will apply the filter properly on the variable TransactionType.
  Another pie chart GroupType with the data link with GroupType will apply the filter properly on the variable GroupType. BUT it will cancel any the previous filter applied.

  That’s because a datalink as i’ve described above is recalling a link with the saved dashboard where no filter is aplied. Each time the data link is called it’s not adding to the existing filters but restarting from the saved version.

  How can we make it so the datalink apply the filter on top of the existing filter appled 
  
  **Discussion**:
  
It seems like this user is trying to manually create drilldowns. They aren't supported as a feature yet, though there is lots of discussion about them. The conclusion is that it's not possible yet. 

**Topic Trends**

- Top posts in user-essentials category: 
  - Walk through of how to find the top posts in each category. User-essentials covers a lot of different categories, so we'll do a quick demo.
  - This post [How to hide zero or null values in Legend in Grafana 8](https://community.grafana.com/t/how-to-hide-zero-or-null-values-in-legend-in-grafana-8/54369) has 6.1k views the related GH Discussion has 200 votes.

**Needs Investigation**

https://github.com/grafana/grafana/issues?q=is%3Aopen+is%3Aissue+label%3A%22needs+investigation%22+project%3Agrafana%2F78

## First Meeting! June 15
**Alerting Squad**

We'd love to hear feedback about the format and topics that are most useful and how the community support squad can help! 

**Community Forum Posts**

- https://community.grafana.com/t/how-can-i-dynamically-pass-value-from-my-alert-condition-query-condition-to-my-notification/66566
  
  **Summary**: In notification under labels I want to pass my last() value and the threshold value (last() value is the recent value from influxDB & threshold value is 10 as per screenshot)dynamically. Screenshot shows they're using the MS Teams notifier.
 
  **Discussion**: 
  
  The team gave us some internal issues to look at that have examples of how to use annotations with message templates to get values from the available templating data:
  
```
  Values: {{ $values }}
B0 obj: {{ $values.B0 }}
B0 value {{ $values.B0.Value }}
B0 instance {{ $values.B0.Labels.instance }}

```

They also explained that invalid templates cause the expansion to fail and therefore are replaced by the template itself.

Next steps: The community squad will give this a try and respond to the user above with a suggestion. 
  
  
- Github issue & Forum Posts about Grafana 8 alerts API: 
  
  https://github.com/grafana/grafana/issues/50150 
  
  https://community.grafana.com/t/manage-alerts-delete-modify-using-api-for-unified-alerting-interface/66285
  
  **Summary**: Users are asking about how to manage Grafana 8 alerts with the API. We see our docs point to swagger.io - we get stuck knowing which APIs to use
  
  **Discussion**: 
  
  The API is still in development, there is a new swagger doc that includes only the APIs which are considered backwards compatible and stable. An effort has been made to add descriptions to the alert provisioning APIs. 
  
  https://editor.swagger.io/?url=https://raw.githubusercontent.com/grafana/grafana/main/pkg/services/ngalert/api/tooling/api.json
  

**Topic Trends**

- Alerting on multiple series/template variables (multidimensional rules)
- Confusion about where to get started with alerting - asking for basic instructions/overview
- Message templating!!!! Matt created this filtered view of the most viewed topics tagged for alert-templating: 
  https://community.grafana.com/tags/c/support/33/alert-templating?order=views
  
  https://community.grafana.com/t/grafana-8-alerting-value-template/53141/11 has 3.2k views!
  
**Bonus Topic**
  
Grafana 9 released yesterday. The squad shared that there could be some potential confusion with the alert migration process. Especially for users that are moving from legacy alerting if they had snapshots enabled in their alerts. The old configuration settings for legacy alerting aren't referenced in the migration, so users will want to be sure that they follow the migration guide AND add new configuration flags to enable images in the new alerting.

To do: The community squad will create a forum post about missing snapshots and other potential migration issues - we'll reference the docs and check google analytics to see how useful the community finds it. 
 

