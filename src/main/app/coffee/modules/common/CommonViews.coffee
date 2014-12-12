IssueTrackerApp.module 'Common', (Common, IssueTrackerApp, Backbone, Marionette, $, _) ->

  # Define the View for a Modal Dialog Box
  class Common.DialogView extends Backbone.Marionette.ItemView

    className: 'modal fade'

    template: 'dialog'

    triggers:
      'click .js-primary': 'primary'
      'click .js-secondary': 'secondary'

    serializeData: ->
      @options

    onShow: ->
      @$el.modal 'show'

    onHide: ->
      @$el.modal 'hide'
