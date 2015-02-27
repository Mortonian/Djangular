from rest_framework import serializers

from .models import Question, Choice, Feedback

class ChoiceSerializer(serializers.ModelSerializer):

    class Meta:
        model = Choice
        fields = ('choice_text', 'question', 'id', 'votes')

class FeedbackSerializer(serializers.ModelSerializer):
    pub_date = serializers.DateTimeField(required=False)
    
    class Meta:
        model = Feedback
        fields = ('feedback_text', 'question', 'id', 'pub_date')

class QuestionSerializer(serializers.ModelSerializer):
    choices = ChoiceSerializer(many=True)
    feedbacks = FeedbackSerializer(many=True)

    class Meta:
        model = Question
        fields = ('question_text', 'choices', 'feedbacks', 'id')

