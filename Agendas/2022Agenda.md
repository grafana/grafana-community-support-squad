# Community Support Office Hours - 2022 Agenda

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
 

