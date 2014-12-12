IssueTrackerApp.module 'Header', (Header, IssueTrackerApp, Backbone, Marionette, $, _) ->

  class Header.NavBarView extends Backbone.Marionette.ItemView

    template: 'navbar',

    ui:
      navigation: '.js-nav'

    events:
      'click @ui.navigation': 'onNavigationClicked'

    onNavigationClicked: (e) ->
      e.preventDefault()
      commandName = $(e.target).attr 'data-nav-target'
      IssueTrackerApp.execute commandName
