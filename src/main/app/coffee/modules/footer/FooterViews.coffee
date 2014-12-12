IssueTrackerApp.module 'Footer', (Footer, IssueTrackerApp, Backbone, Marionette, $, _) ->

  class Footer.FooterView extends Backbone.Marionette.ItemView

    className: 'container-fluid'

    template: 'footer'
