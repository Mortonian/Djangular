services = angular.module('pollApp.services', [])


services.factory('Choice', ($http, $log)->
    class Choice
        constructor: (data) ->
            @choice_text = data.choice_text
            @id = data.id
            @votes = data.votes

        update : ->
            data = {'votes' : @votes, 'choice_text' : @choice_text}
            $http({method: 'PUT', url: '/polls/choices/' + @id + '/', data:data})
            .success (data) =>
                $log.info("Succesfully voted")
            .error (data) =>
                $log.info("Failed to vote.")

    return Choice
)

services.factory('Feedback', ($http, $log)->
    #log = $log
    class Feedback
        constructor: (data) ->
            @feedback_text = data.feedback_text
            @id = data.id
            @pub_date = data.pub_date

        update : ->
            data = {'feedback_text' : @feedback_text}
            $http({method: 'PUT', url: '/polls/feedbacks/' + @id + '/', data:data})
            .success (data) =>
                $log.info("Succesfully left feedback")
            .error (data) =>
                $log.info("Failed to leave feedback.")

    return Feedback
)

services.factory('Question', (Choice, Feedback, $http, $log) ->
    class Question
        constructor : (data) ->
            if data != null
                @init(data)
        init : (data) ->
            @question_text = data.question_text
            @id = data.id
            @choices = []
            @feedbacks = []
            @totalVotes = 0
            for choice in data.choices
                c = new Choice(choice)
                @totalVotes += c.votes
                @choices.push(new Choice(choice))
            for feedback in data.feedbacks
                @feedbacks.push(new Feedback(feedback))

        get : (questionId) ->
            $http({method: 'GET', url: '/polls/questions/' + questionId + '/'})
            .success (data) =>
                @init(data)
                $log.info("Succesfully fetched question")
            .error (data) =>
                $log.info("Failed to fetch question.")

        addFeedback: (feedbackText) ->
            data = {'feedback_text' : feedbackText, 'question' : @id }
            $log.info("trying to add feedback: " + data)
            $http({method: 'POST', url: '/polls/feedbacks', data:data})
            .success (data) =>
                $log.info("Succesfully added feedback: "+data)
                @feedbacks.push(new Feedback(data))
                return ""
            .error (data) =>
                $log.info("Failed to add feedback: "+data)
                return feedbackText

    return Question
)

services.factory('Questions', ($log, $http, Question) ->
    questions = {
        all : []
    }

    fromServer: (data) ->
        questions['all'].length = 0
        for question in data
            questions['all'].push(new Question(question))

    fetch: ->
        $http({method: 'GET', url: '/polls/questions'})
            .success (data) =>
                @fromServer(data)
                $log.info("Succesfully fetched questions.")
            .error (data) =>
                $log.info("Failed to fetch questions.")

    data : ->
        return questions
)


