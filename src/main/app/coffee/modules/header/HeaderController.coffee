IssueTrackerApp.module 'Header', (Header, IssueTrackerApp, Backbone, Marionette, $, _) ->

  # Define the Controller for the Header module
  class HeaderController extends Marionette.Controller

    show: ->
      logger.debug "HeaderController.show"
      navBarView = new Header.NavBarView()
      IssueTrackerApp.headerRegion.show navBarView


  # Create an instance
  controller = new HeaderController()


  # When the module is initialized...
  Header.addInitializer ->
    logger.debug "Header initializer"
    controller.show()
