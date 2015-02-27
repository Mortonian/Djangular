services = angular.module('pollApp.services', [])


services.factory('Choice', ($http, $log)->
    class Choice
        constructor: (data) ->
            @choice_text = data.choice_text
            @id = data.id
            @votes = data.votes

        update : (cb) ->
            data = {'votes' : @votes, 'choice_text' : @choice_text}
            $http({method: 'PUT', url: '/polls/choices/' + @id + '/', data:data})
            .success (data) =>
                $log.info("Succesfully voted")
                cb()
            .error (data) =>
                $log.info("Failed to vote.")
                cb()

    return Choice
)

services.factory('Feedback', ($http, $log)->
    #log = $log
    class Feedback
        constructor: (data) ->
            @feedback_text = data.feedback_text
            @id = data.id
            @pub_date = data.pub_date
            @pub_date_fmt = moment(data.pub_date).calendar()

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
            @lastResponseDate = data.last_response_date
            @lastResponseDateFmt = moment(data.last_response_date).fromNow()
            @upvotes = data.upvotes
            for choice in data.choices
                c = new Choice(choice)
                @totalVotes += c.votes
                @choices.push(new Choice(choice))
            for feedback in data.feedbacks
                @feedbacks.push(new Feedback(feedback))

        upvote : () ->
            if @upvotes 
                @upvotes = @upvotes + 1
            else 
                @upvotes = 1
            $http({method: 'POST', url: '/polls/questions/' + @id + '/upvote'})
            .success (data) =>
                @upvotes = data.upvotes
                $log.info("Succesfully upvoted")
            .error (data) =>
                $log.info("Failed to upvote.")

        downvote : () ->
            if @upvotes 
                @upvotes = @upvotes - 1
            else 
                @upvotes = -1
            $http({method: 'POST', url: '/polls/questions/' + @id + '/downvote'})
            .success (data) =>
                @upvotes = data.upvotes
                $log.info("Succesfully downvoted")
            .error (data) =>
                $log.info("Failed to downvote.")

        get : (questionId) ->
            $http({method: 'GET', url: '/polls/questions/' + questionId + '/'})
            .success (data) =>
                @init(data)
                $log.info("Succesfully fetched question")
            .error (data) =>
                $log.info("Failed to fetch question.")

        voteOnChoice : (voteChoice, cb) ->
            for choice in @choices
                if choice.id == voteChoice
                    choice.votes+=1
                    @totalVotes+=1
                    choice.update(cb)
                    break

        addFeedback: (feedbackText) ->
            data = {'feedback_text' : feedbackText, 'question' : @id }
            $http({method: 'POST', url: '/polls/feedbacks', data:data})
            .success (data) =>
                $log.info("Succesfully added feedback")
                @feedbacks.push(new Feedback(data))
            .error (data) =>
                $log.info("Failed to add feedback")

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
        questions['all'] = questions['all'].sort((a,b) ->  b.upvotes - a.upvotes )

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


