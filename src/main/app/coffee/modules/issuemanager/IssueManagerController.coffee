IssueTrackerApp.module 'IssueManager', (IssueManager, IssueTrackerApp, Backbone, Marionette, $, _) ->

  # Define the AppRouter for the IssueManager module
  class IssueManagerRouter extends Marionette.AppRouter

    appRoutes:
      'issues': 'list'
      'issues/:id': 'view'


  # Define the Controller for the IssueManager module
  class IssueManagerController extends Marionette.Controller

    list: (collection) ->
      logger.debug "IssueManagerController.list"

      displayListView = (issueCollection) ->
        listView = new IssueManager.IssueListView
          collection: issueCollection

        # Handle 'issue:view' events triggered by Child Views
        listView.on 'childview:issue:view', (args) ->
          logger.debug "Handling 'childview:issue:view' event"
          IssueTrackerApp.execute 'issuemanager:view', args.model.get('id'), args.model, issueCollection

        # Handle 'issue:edit' events triggered by Child Views
        listView.on 'childview:issue:edit', (args) ->
          logger.debug "Handling 'childview:issue:edit' event"
          IssueTrackerApp.execute 'issuemanager:edit', args.model.get('id'), args.model, issueCollection

        # Handle 'issue:delete' events triggered by Child Views
        listView.on 'childview:issue:delete', (args) ->
          logger.debug "Handling 'childview:issue:delete' event"
          dialogView = new IssueTrackerApp.Common.DialogView
            title: 'Delete Issue?'
            body: 'Click confirm to permanently delete this issue.'
            primary: 'Confirm'
            secondary: 'Cancel'

          dialogView.on 'primary', ->
            logger.debug "Handling 'primary' dialog event"
            args.model.destroy()
            dialogView.triggerMethod 'hide'

          dialogView.on 'secondary', ->
            logger.debug "Handling 'secondary' dialog event"
            dialogView.triggerMethod 'hide'

          IssueTrackerApp.dialogRegion.show dialogView

        logger.debug "Show IssueListView in IssueTrackerApp.mainRegion"
        IssueTrackerApp.mainRegion.show listView

      if collection?
        displayListView collection
      else
        fetchingIssues = IssueTrackerApp.request 'issue:entities'
        $.when(fetchingIssues).done (issues) ->
          displayListView issues

    add: ->
      logger.debug "IssueManagerController.add"
      addIssueView = new IssueManager.IssueAddView

      # Handle 'form:cancel' event
      addIssueView.on 'form:cancel', ->
        logger.debug "Handling 'form:cancel' event"
        IssueTrackerApp.execute 'issuemanager:list'

      # Handle 'form:submit' trigger
      addIssueView.on 'form:submit', (data) ->
        logger.debug "Handling 'form:submit' event"
        logger.debug "form data:" + JSON.stringify data
        issueModel = new IssueTrackerApp.Entities.Issue
        if issueModel.save(data,
            success: ->
              IssueTrackerApp.execute 'issuemanager:view', issueModel.get('id'), issueModel
            error: ->
              alert 'An unexpected problem has occurred.'
          )
        else
          # handle validation errors
          addIssueView.triggerMethod 'form:validation:failed', issueModel.validationError

      logger.debug "Show IssueAddView in IssueTrackerApp.mainRegion"
      IssueTrackerApp.mainRegion.show addIssueView

    edit: (id, model, collection) ->
      logger.debug "IssueManagerController.edit"

      displayEditView = (issueModel, issueCollection) ->
        editIssueView = new IssueManager.IssueEditView
          model: issueModel

        # Handle 'form:cancel' event
        editIssueView.on 'form:cancel', ->
          logger.debug "Handling 'form:cancel' event"
          IssueTrackerApp.execute 'issuemanager:view', id, issueModel, issueCollection

        # Handle 'form:submit' event
        editIssueView.on 'form:submit', (data) ->
          logger.debug "Handling 'form:submit' event"
          logger.debug "form data:" + JSON.stringify data
          if issueModel.save(data,
              success: ->
                IssueTrackerApp.execute 'issuemanager:view', id, issueModel, issueCollection
              error: ->
                alert 'An unexpected problem has occurred.'
            )
          else
            # handle validation errors
            editIssueView.triggerMethod 'form:validation:failed', issueModel.validationError

        logger.debug "Show IssueEditView in IssueTrackerApp.mainRegion"
        IssueTrackerApp.mainRegion.show editIssueView

      if model?
        displayEditView model, collection
      else
        fetchingIssue = IssueTrackerApp.request 'issue:entity', id
        $.when(fetchingIssue).done (issue) ->
          displayEditView issue, collection

    view: (id, model, collection) ->
      logger.debug "IssueManagerController.view id:#{ id }"

      displayView = (issueModel, issueCollection) ->
        issueView = new IssueManager.IssueView
          model: issueModel

        issueView.on 'issue:list', (args) ->
          logger.debug "Handling 'issue:list' event"
          IssueTrackerApp.execute 'issuemanager:list', issueCollection

        issueView.on 'issue:edit', ->
          logger.debug "Handling 'issue:edit' event"
          IssueTrackerApp.execute 'issuemanager:edit', issueModel.get('id'), issueModel, issueCollection

        logger.debug "Show IssueView in IssueTrackerApp.mainRegion"
        IssueTrackerApp.mainRegion.show issueView

      if model?
        displayView model, collection
      else
        fetchingIssue = IssueTrackerApp.request 'issue:entity', id
        $.when(fetchingIssue).done (issue) ->
          displayView issue, collection


  # Create an instance
  controller = new IssueManagerController


  # When the module is initialized...
  IssueManager.addInitializer ->
    logger.debug "IssueManager initializer"
    router = new IssueManagerRouter
      controller: controller


  # Handle application commands...
  IssueTrackerApp.commands.setHandler 'issuemanager:list', (collection) ->
    logger.debug "Handling 'issuemanager:list' command"
    IssueTrackerApp.navigate 'issues'
    controller.list collection

  IssueTrackerApp.commands.setHandler 'issuemanager:add', ->
    logger.debug "Handling 'issuemanager:add' command"
    controller.add()

  IssueTrackerApp.commands.setHandler 'issuemanager:edit', (id, model, collection) ->
    logger.debug "Handling 'issuemanager:edit' command"
    controller.edit id, model, collection

  IssueTrackerApp.commands.setHandler 'issuemanager:view', (id, model, collection) ->
    logger.debug "Handling 'issuemanager:view' command"
    IssueTrackerApp.navigate "issues/#{ id }"
    controller.view id, model, collection
