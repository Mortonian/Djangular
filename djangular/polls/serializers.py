from rest_framework import serializers

from .models import Question, Choice, Feedback

class ChoiceSerializer(serializers.ModelSerializer):
    question = serializers.PrimaryKeyRelatedField(required=False, read_only=True)

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
    last_response_date = serializers.DateTimeField(required=False)
    upvotes = serializers.IntegerField(required=False)

    class Meta:
        model = Question
        # 'last_response_date'
        fields = ('question_text', 'last_response_date', 'upvotes', 'choices', 'feedbacks', 'id')

