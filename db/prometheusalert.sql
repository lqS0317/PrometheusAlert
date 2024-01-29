PRAGMA synchronous = OFF;
    PRAGMA journal_mode = MEMORY;
BEGIN TRANSACTION;
CREATE TABLE `prometheus_alert_d_b` (
                                      `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT
  ,  `tpltype` varchar(255) NOT NULL DEFAULT ''
  ,  `tpluse` varchar(255) NOT NULL DEFAULT ''
  ,  `tplname` varchar(255) NOT NULL DEFAULT ''
  ,  `tpl` longtext NOT NULL
  ,  `created` datetime NOT NULL
);

INSERT INTO `prometheus_alert_d_b` VALUES ('3', 'fs', 'Prometheus', 'prometheus-fsv2', '
    {{ $var := .externalURL}}
    {{- range $k,$v:=.alerts -}}
    {{ if eq $v.status "resolved" -}}
    **✅✅✅[{{$v.status}} {{$v.labels.env}}]({{$v.generatorURL}})** *[{{$v.labels.alertname}}]({{$var}})*
    {{- if $v.labels.level}}
    Level：**{{$v.labels.level}}**
    {{- end }}
    Severity：**{{$v.labels.severity}}**
    Start at：{{GetCSTtime $v.startsAt}}
    End   at：{{GetCSTtime $v.endsAt}}
    **Alert Detail:**
      {{- if $v.annotations.summary}}
      *summary*: {{$v.annotations.summary}}
      {{- end }}
      *description*: **{{ $v.annotations.description }}**
    **Event Lables:**
    {{- range $key,$value:=$v.labels }}
    {{- if or (eq $key "alertname") (eq $key "severity") (eq $key "level") (eq $key "mediatype") (eq $key "prometheus") (eq $key "endpoint")}}
    {{- else}}
      > {{- $key}}：{{$value -}}
    {{- end}}
    {{- end }}

    {{ else -}}
    **💥💥💥[{{$v.status}} {{$v.labels.env}}]({{$v.generatorURL}})** *[{{$v.labels.alertname}}]({{$var}})*
    {{- if $v.labels.level}}
    Level：**{{$v.labels.level}}**
    {{- end }}
    Severity：**{{$v.labels.severity}}**
    Start at：{{GetCSTtime $v.startsAt}}
    **Alert Detail:**
      {{- if $v.annotations.summary}}
      *summary*: {{$v.annotations.summary}}
      {{- end }}
      *description*: **{{ $v.annotations.description }}**
    **Event Lables:**
    {{- range $key,$value:=$v.labels }}
    {{- if or (eq $key "alertname") (eq $key "severity") (eq $key "level") (eq $key "mediatype") (eq $key "prometheus") (eq $key "endpoint")}}
    {{- else}}
      > {{- $key}}：{{$value -}}
    {{- end}}
    {{- end }}
    Link: **[Silence]({{$v.annotations.alertmanager_url}})** | **[Grafana]({{$v.annotations.grafana_url}})** | **[RunbookV2]({{$v.annotations.runbook_v2_url}})**
      {{- if $v.annotations.at}}
    At: {{html $v.annotations.at}}
      {{- end }}

    {{ end -}}
    {{- end -}}
    ', '2020-12-22 03:07:39');

INSERT INTO `prometheus_alert_d_b` VALUES ('4', 'fs', 'Prometheus', 'prometheus-elastalert-fs', '
    {{ $var := .externalURL}}
    {{- range $k,$v:=.alerts -}}
    {{- if eq $v.status "resolved" -}}
    **✅✅✅[{{$v.status}} {{$v.labels.env}}]({{$v.generatorURL}})** *[{{$v.labels.alertname}}]({{$var}})*
    **===故障已恢复===**
    {{- if $v.labels.level}}
    Level：**{{$v.labels.level}}**
    {{- end }}
    Severity：**{{$v.labels.severity}}**
    Start at：{{GetCSTtime $v.startsAt}}
    End   at：{{GetCSTtime $v.endsAt}}
    Owners: **{{$v.labels.owners}}**, OU: **{{$v.labels.ou}}**, Env: **{{$v.labels.env}}**
    NumHit：**{{$v.labels.num_hit}}**, AppName：**{{$v.labels.appname}}**,
    Msg：**{{$v.labels.msg}}**
    {{- else -}}
    **💥💥💥[{{$v.status}} {{$v.labels.env}}]({{$v.generatorURL}})** *[{{$v.labels.alertname}}]({{$var}})*
    **===侦测到故障===**
    {{- if $v.labels.level}}
    Level：**{{$v.labels.level}}**
    {{- end }}
    Severity：**{{$v.labels.severity}}**
    Start at：{{GetCSTtime $v.startsAt}}
    Owners: **{{$v.labels.owners}}**, OU: **{{$v.labels.ou}}**, Env: **{{$v.labels.env}}**
    NumHit：**{{$v.labels.num_hit}}**, AppName：**{{$v.labels.appname}}**,
    Msg：**{{$v.labels.msg}}**
    Link: **[Runbook]({{$v.annotations.runbook_url}})** | **[Grafana]({{$v.annotations.grafana_url}})**
    At: {{html $v.annotations.at}}
    {{- end -}}
    {{- end -}}
    ', '2020-12-22 03:07:39');

CREATE TABLE `alert_record` (
                              `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT
  ,                                `send_type` varchar(255) NOT NULL DEFAULT ''
  ,                                `alertname` varchar(255) NOT NULL DEFAULT ''
  ,                                `alert_level` varchar(255) NOT NULL DEFAULT ''
  ,                                `business_type` varchar(255) NOT NULL DEFAULT ''
  ,                                `instance` varchar(255) NOT NULL DEFAULT ''
  ,                                `starts_at` varchar(255) NOT NULL DEFAULT ''
  ,                                `ends_at` varchar(255) NOT NULL DEFAULT ''
  ,                                `summary` varchar(255) NOT NULL DEFAULT ''
  ,                                `description` varchar(255) NOT NULL DEFAULT ''
  ,                                `handle_status` varchar(255) NOT NULL DEFAULT ''
  ,                                `alert_status` varchar(255) NOT NULL DEFAULT ''
  ,                                `alert_json` varchar(255) NOT NULL DEFAULT ''
  ,                                `remark` varchar(255) NOT NULL DEFAULT ''
  ,                                `revision` integer NOT NULL DEFAULT '0'
  ,                                `created_by` varchar(255) NOT NULL DEFAULT ''
  ,                                `created_time` datetime NOT NULL
  ,                                `updated_by` varchar(255) NOT NULL DEFAULT ''
  ,                                `updated_time` datetime NOT NULL
);
CREATE INDEX "idx_prometheus_alert_d_b_prometheus_alert_d_b_tplname" ON "prometheus_alert_d_b" (`tplname`);
END TRANSACTION;
