# Issue triage handbook
## Tips for more efficient triaging

The official triage documentation can be found in [ISSUE_TRIAGE](https://github.com/grafana/grafana/blob/main/ISSUE_TRIAGE.md). These are just some tips that can help you follow those guidelines, and thus triage issues more efficiently. 

**Table of contents**
- [Scan for issues created by Grafanistas](#scan-for-issues-created-by-grafanistas)
- [Identify when an issue should be pass to the devs](#identify-when-an-issue-should-be-pass-to-the-devs)
- [Use the CHANGELOG to scan for the source of an issue](#use-the-changelog-to-scan-for-the-source-of-an-issue)
___

### Scan for issues created by Grafanistas
Even though we try to remind everyone in Grafana Labs to label their issues when they create them, not everyone remembers this every time. Issues created by Grafananistas are usually easier to triage and can be quickly redirected to the squads, so scanning for them can be a way to quickly reduce the amount of issues in triage. 

To know whether a user is part of Grafana Labs, you can hover over their username. If they're part of our org you'll be able to see it in the tooltip as "Member of Grafana Labs".

### Identify when an issue should be passed to the devs
- If the issue involves a hard setup that'd take a long time: label it, add it to a project, and move on.
- If there's enough evidence that shows a developer should look into it (even if you haven't been able to reproduce it): label, add it to the project, and move on.


### Use the CHANGELOG to scan for the source of an issue
As part of triage, we try to provide as much information before passing it to our devs regarding the issue, part of that work involves doing some high level research of when that issue had been introduced. Our [CHANGELOG](https://github.com/grafana/grafana/blob/main/CHANGELOG.md) is a great source to gather this info. Here are some tips on how to use it:
- From the reported issue, try to identify in which version was introduced. E.g if the user says it worked in 9.2.0 and not in 9.2.3, the issue was probably introduce between those releases. This helps you filter out irrelevant releases.
- Search for keywords. E.g `Variables`, `Annotations`, `Azure`.

If you find a PR (or more) that could have introduced the reported issue, add the info to the latter.