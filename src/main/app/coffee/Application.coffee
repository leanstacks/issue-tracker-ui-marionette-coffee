# Customize the Renderer to use Namespacing
Backbone.Marionette.Renderer.render = (template, data) ->
  IssueTrackerTemplates[template](data)


# Create the Application
window.IssueTrackerApp = new Backbone.Marionette.Application()


# Navigate to a route
IssueTrackerApp.navigate = (route, options) ->
  logger.debug "IssueTrackerApp.navigate route: #{ route }"
  options || ( options = {} )
  Backbone.history.navigate route, options


# Retrieve the current route
IssueTrackerApp.getCurrentRoute = () ->
  Backbone.history.fragment


# Create the top-level Regions
IssueTrackerApp.addRegions
  headerRegion : '#header-region'
  mainRegion   : '#main-region'
  dialogRegion : '#dialog-region'
  footerRegion : '#footer-region'


# Application start Callback Function
IssueTrackerApp.on 'start', (options) ->
  # Initialize the Router
  logger.debug "Backbone.history.start"
  Backbone.history.start()

  # Launch the Issue List
  if IssueTrackerApp.getCurrentRoute() is ''
    IssueTrackerApp.execute 'issuemanager:list'


# Start the Application
$ ->
  # Configure log4javascript Library
  window.logger = log4javascript.getLogger()
  consoleAppender = new log4javascript.BrowserConsoleAppender()
  consoleAppender.setLayout new log4javascript.PatternLayout '%d{HH:mm:ss} %-5p - %m'
  window.logger.addAppender consoleAppender

  # Start Marionette Application
  logger.debug "IssueTrackerApp.start"
  IssueTrackerApp.start()
