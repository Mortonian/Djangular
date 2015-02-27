from rest_framework import generics, permissions, views
from rest_framework.response import Response
from .models import Question, Choice, Feedback
from .serializers import QuestionSerializer, ChoiceSerializer, FeedbackSerializer
from django.shortcuts import render


class QuestionList(generics.ListCreateAPIView):
    queryset = Question.objects.all()
    #model = Question
    serializer_class = QuestionSerializer
    permission_classes = [
        permissions.AllowAny
    ]

class QuestionDetail(generics.RetrieveAPIView):
	queryset = Question.objects.all()
	#model = Question
	serializer_class = QuestionSerializer
	lookup_url_kwarg = 'question_pk'
	permission_classes = [
		permissions.AllowAny
	]

class ChoiceUpdate(generics.UpdateAPIView):
	queryset = Choice.objects.all()
	#model = Choice
	serializer_class = ChoiceSerializer
	lookup_url_kwarg = 'choice_pk'
	permission_classes = [
		permissions.AllowAny
	]

class ChoiceList(generics.ListCreateAPIView):
    queryset = Choice.objects.all()
    #model = Choice
    serializer_class = ChoiceSerializer
    permission_classes = [
        permissions.AllowAny
    ]

class FeedbackUpdate(generics.UpdateAPIView):
	queryset = Feedback.objects.all()
	serializer_class = FeedbackSerializer
	lookup_url_kwarg = 'feedback_pk'
	permission_classes = [
		permissions.AllowAny
	]

class FeedbackList(generics.ListCreateAPIView):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackSerializer
    permission_classes = [
        permissions.AllowAny
    ]

class UpvoteApiView(views.APIView):

    def post(self, request, *args, **kwargs):
        question = Question.objects.get(id=kwargs['question_pk'])
        if question.upvotes:
            question.upvotes = question.upvotes+1
        else:
            question.upvotes = 1
        question.save()
        return Response({"question": question.id, "upvotes": question.upvotes, "success": True})

class DownvoteApiView(views.APIView):

    def post(self, request, *args, **kwargs):
        question = Question.objects.get(id=kwargs['question_pk'])
        if question.upvotes:
            question.upvotes = question.upvotes-1
        else:
            question.upvotes = -1
        question.save()
        return Response({"question": question.id, "upvotes": question.upvotes, "success": True})

def index(request):
    return render(request, 'polls/index.html')
