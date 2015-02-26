from rest_framework import serializers

from .models import Question, Choice, Feedback

class ChoiceSerializer(serializers.ModelSerializer):

    class Meta:
        model = Choice
        fields = ('choice_text', 'id', 'votes')

class FeedbackSerializer(serializers.ModelSerializer):

    class Meta:
        model = Feedback
        fields = ('feedback_text', 'id', 'pub_date')

class QuestionSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True)
    feedbacks = FeedbackSerializer(many=True)

    class Meta:
        model = Question
        fields = ('question_text', 'choices', 'feedbacks', 'id')

