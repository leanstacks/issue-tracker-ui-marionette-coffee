IssueTrackerApp.module 'Footer', (Footer, IssueTrackerApp, Backbone, Marionette, $, _) ->

  # Define the Controller for the Footer module
  class FooterController extends Marionette.Controller

    show: ->
      logger.debug "FooterController.show"
      footerView = new Footer.FooterView()
      IssueTrackerApp.footerRegion.show footerView


  # Create an instance
  controller = new FooterController()


  # When the module is initialized...
  Footer.addInitializer ->
    logger.debug "Footer initializer"
    controller.show()
