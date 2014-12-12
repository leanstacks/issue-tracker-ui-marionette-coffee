IssueTrackerApp.module 'IssueManager', (IssueManager, IssueTrackerApp, Backbone, Marionette, $, _) ->

  # Define the View for an empty List of Issues
  class IssueManager.IssueListEmptyView extends Backbone.Marionette.ItemView

    tagName: 'tr'

    template: 'issuelistempty'


  # Define the View for a single Issue in the List
  class IssueManager.IssueListItemView extends Backbone.Marionette.ItemView

    tagName: 'tr'

    template: 'issuelistitem'

    modelEvents:
      'change': 'render'

    triggers:
      'click .js-view': 'issue:view'
      'click .js-edit': 'issue:edit'
      'click .js-delete': 'issue:delete'


  # Define the View for a List of Issues
  class IssueManager.IssueListView extends Backbone.Marionette.CompositeView

    emptyView: IssueManager.IssueListEmptyView

    childView: IssueManager.IssueListItemView

    childViewContainer: 'tbody'

    className: 'container-fluid'

    template: 'issuelist'


  # Define the View for Adding an Issue
  class IssueManager.IssueAddView extends Backbone.Marionette.ItemView

    className: 'container-fluid'

    template: 'issueadd'

    ui:
      createButton: 'button.js-create'
      cancelButton: 'button.js-cancel'

    events:
      'click @ui.createButton': 'onCreateClicked'

    triggers:
      'click @ui.cancelButton': 'form:cancel'

    onCreateClicked: (e) ->
      logger.debug "IssueAddView.onCreateClicked"
      e.preventDefault()
      @showProcessingState()
      data = Backbone.Syphon.serialize @
      @trigger 'form:submit', data

    showProcessingState: ->
      spinnerContent = '<i class="fa fa-circle-o-notch fa-spin"></i> '
      @ui.createButton.button 'loading'
      @ui.createButton.prepend spinnerContent

    hideProcessingState: ->
      @ui.createButton.button 'reset'

    onFormValidationFailed: (errors) ->
      @hideProcessingState()
      @hideFormErrors()
      _.each errors, @showFormError, @

    showFormError: (errorMessage, fieldKey) ->
      $formControl = @$el.find '[name="'+fieldKey+'"]'
      $controlGroup = $formControl.parents '.form-group'
      errorContent = '<span class="help-block js-form-error">' + errorMessage + '</span>'
      $formControl.after errorContent
      $controlGroup.addClass 'has-error'

    hideFormErrors: ->
      @$el.find('.js-form-error').each ->
        $(@).remove()
      @$el.find('.form-group.has-error').each ->
        $(@).removeClass 'has-error'


  # Define the View for Editing an Issue
  class IssueManager.IssueEditView extends Backbone.Marionette.ItemView

    className: 'container-fluid'

    template: 'issueedit'

    ui:
      updateButton: 'button.js-update'
      cancelButton: 'button.js-cancel'

    events:
      'click @ui.updateButton': 'onUpdateClicked'

    triggers:
      'click @ui.cancelButton': 'form:cancel'

    onUpdateClicked: (e) ->
      logger.debug "IssueEditView.onUpdateClicked"
      e.preventDefault()
      @showProcessingState()
      data = Backbone.Syphon.serialize @
      @trigger 'form:submit', data

    showProcessingState: ->
      spinnerContent = '<i class="fa fa-circle-o-notch fa-spin"></i> '
      @ui.updateButton.button 'loading'
      @ui.updateButton.prepend spinnerContent

    hideProcessingState: ->
      @ui.updateButton.button 'reset'

    onFormValidationFailed: (errors) ->
      @hideProcessingState()
      @hideFormErrors()
      _.each errors, @showFormError, @

    showFormError: (errorMessage, fieldKey) ->
      $formControl = @$el.find '[name="'+fieldKey+'"]'
      $controlGroup = $formControl.parents '.form-group'
      errorContent = '<span class="help-block js-form-error">' + errorMessage + '</span>'
      $formControl.after errorContent
      $controlGroup.addClass 'has-error'

    hideFormErrors: ->
      @$el.find('.js-form-error').each ->
        $(@).remove()
      @$el.find('.form-group.has-error').each ->
        $(@).removeClass 'has-error'


  # Define the View for a Single Issue
  class IssueManager.IssueView extends Backbone.Marionette.ItemView

    className: 'container-fluid'

    template: 'issueview'

    triggers:
      'click .js-list': 'issue:list'
      'click .js-edit': 'issue:edit'
