controllers = angular.module('pollApp.controllers', [])

controllers.controller('questionListController', ($scope, $state, $log, questions) ->
  $scope.questions = questions.all
  $scope.sortQuestions = (questions) ->
        questions.sort((a,b) ->  b.upvotes - a.upvotes )

  $scope.upvote = (question) ->
    question.upvote()
    $scope.questions = $scope.sortQuestions($scope.questions)

  $scope.downvote = (question) ->
    question.downvote()
    $scope.questions = $scope.sortQuestions($scope.questions)
)

controllers.controller('questionDetailController', ($scope, $state, $log, question) ->
  $scope.question = question
  $scope.voteChoice = 0

  $scope.vote = ->
    question.voteOnChoice(parseInt($scope.voteChoice), () -> $state.go('questionResults', {questionId:question.id}))
)

controllers.controller('questionResultsController', ($scope, $state, $log, question) ->
  $scope.question = question

  $scope.submitFeedback = ->
    question.addFeedback($scope.feedbackToSubmit.feedback_text)
    $scope.feedbackToSubmit.feedback_text = ''
)

