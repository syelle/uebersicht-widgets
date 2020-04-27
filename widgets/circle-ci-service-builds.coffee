colors =
  standard: '#525252'
  queued  : '#999999'
  running : '#525252'
  success : '#80b95b'
  failed  : '#ff1e7a'
  fixed   : '#80b95b'

refreshFrequency: 30000

command: "./circle-ci-get-workflow-executions.pl"

update: (output, domEl) ->
  data = JSON.parse(output)
  workflow_executions = data

  table  = $(domEl).find('table')

  # Reset the table
  table.html('')

  getBuildColorClass = (status, created_at) ->
    build_color_class = 'elevated'

    old_build_threshhold = new Date()
    old_build_threshhold.setDate(new Date().getDate() - 4)
    created_at_date = new Date(created_at)

    if status == 'success'
      if created_at_date < old_build_threshhold
        build_color_class = 'elevated'
      else
        build_color_class = 'nominal'
    else if (status == 'failed' || status == 'error')
      build_color_class = 'critical'
    else if status == 'cancelled'
      build_color_class = 'negligible'
    else if status == 'unauthorized'
      build_color_status = 'issue'

    build_color_class

  formatStatus = (status) ->
    status = 'queued' if status == 'not_running'
    status

  formatDuration = (duration) ->
    duration_minutes = Math.floor(duration / 60)
    duration_seconds = duration - (duration_minutes * 60)
    duration_string = duration_minutes + "m " + duration_seconds + "s "
    duration_string

  formatCreatedAt = (created_at) ->
    created_at_date = new Date(created_at)
    created_at_string = created_at_date.toLocaleDateString() + " @ " + created_at_date.toLocaleTimeString()
    created_at_string

  renderExecution = (workflow_execution) ->
    build_color_class = getBuildColorClass(workflow_execution.status, workflow_execution.created_at )
    """
    <tr>
      <td><span class="#{build_color_class}">#{workflow_execution.repo_name}/#{workflow_execution.branch_name}</span></td>
      <td><span class="#{build_color_class}">#{formatCreatedAt(workflow_execution.created_at)}</span></td>
      <td><span class="#{build_color_class}">#{formatDuration(workflow_execution.duration)}</span></td>
      <td><span class="#{build_color_class}">#{formatStatus(workflow_execution.status)}</span></td>
    </tr>
    """

  table_header = "<tr>"
  table_header += "<th width='100'>REPO/BRANCH</th>"
  table_header += "<th width='155'>INITIATED @</th>"
  table_header += "<th width='70'>DURATION</th>"
  table_header += "<th width='70'>STATUS</th>"
  table_header += "</tr>"

  table.append table_header

  for workflow_execution in workflow_executions
    table.append renderExecution(workflow_execution)

style: """
  top: 390px
  left: 190px

  th
    text-align left
"""

render: -> """
  <link rel='stylesheet' href='./css/style.css'>
  <table id='buildInfo'></table>
"""