IssueTrackerApp.module 'Entities', (Entities, IssueTrackerApp, Backbone, Marionette, $, _) ->

  # Define the Model for an Issue entity
  class Entities.Issue extends Backbone.Model

    urlRoot: 'http://localhost:8080/issues'

    defaults:
      status: 'OPEN'

    validate: (attrs, options) ->
      errors = {}
      if !attrs.title
        errors.title = 'Title is required.'
      if !attrs.description
        errors.description = 'Description is required.'
      if !attrs.type
        errors.type = 'Type is required.'
      if !attrs.priority
        errors.priority = 'Priority is required.'
      if not _.isEmpty errors
        errors


  # Define a Collection of Issue entities
  class Entities.IssueCollection extends Backbone.Collection

    model: Entities.Issue

    url: 'http://localhost:8080/issues'


  # Define the Controller for the Issue Entity
  class IssueEntityController extends Marionette.Controller

    getIssue: (issueId) ->
      logger.debug "IssueEntityController.getIssue"
      issue = new Entities.Issue({ id: issueId })
      defer = $.Deferred()
      issue.fetch
        success: (data) ->
          defer.resolve data
      defer.promise()

    getIssues: ->
      logger.debug "IssueEntityController.getIssues"
      issues = new Entities.IssueCollection()
      defer = $.Deferred()
      issues.fetch
        success: (data) ->
          defer.resolve data
      defer.promise()


  # Create an instance
  issueController = new IssueEntityController()


  # Handle request for an Issue Model
  IssueTrackerApp.reqres.setHandler 'issue:entity', (id) ->
    logger.debug "Handling 'issue:entity' request"
    issueController.getIssue id

  # Handle request for a Collection of Issue Entities
  IssueTrackerApp.reqres.setHandler 'issue:entities', () ->
    logger.debug "Handling 'issue:entities' request"
    issueController.getIssues()
