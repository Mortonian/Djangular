controllers = angular.module('pollApp.controllers', [])

controllers.controller('questionListController', ($scope, $state, $log, questions) ->
  $scope.questions = questions.all
)

controllers.controller('questionDetailController', ($scope, $state, $log, question) ->
  $scope.question = question
  $scope.voteChoice = 0

  $scope.vote = ->
    for choice in $scope.question.choices
        if choice.id == parseInt($scope.voteChoice)
            choice.votes+=1
            $scope.question.totalVotes+=1
            choice.update()
            break
    $state.go('questionResults', {questionId:question.id})
)

controllers.controller('questionResultsController', ($scope, $state, $log, question) ->
  $scope.question = question

  $scope.submitFeedback = ->
    question.addFeedback($scope.feedbackToSubmit.feedback_text)
    $scope.feedbackToSubmit.feedback_text = ''
)

