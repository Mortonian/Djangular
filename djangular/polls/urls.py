from django.conf.urls import patterns, url, include

from .views import QuestionList, ChoiceList, QuestionDetail, ChoiceUpdate, FeedbackList, FeedbackUpdate, UpvoteApiView, DownvoteApiView


urlpatterns = patterns('polls.views',
	url(r'^questions$', QuestionList.as_view(), name='questions_list'),
	url(r'^questions/(?P<question_pk>[0-9]+)/$', QuestionDetail.as_view(), 
			name="questions_detail"),
	url(r'^questions/(?P<question_pk>[0-9]+)/upvote$', UpvoteApiView.as_view(), 
			name="upvote"),
	url(r'^questions/(?P<question_pk>[0-9]+)/downvote$', DownvoteApiView.as_view(), 
			name="downvote"),
	url(r'^choices$', ChoiceList.as_view(), name='choices_list'),
	url(r'^choices/(?P<choice_pk>[0-9]+)/$', ChoiceUpdate.as_view(), 
			name='choices_update'),
	url(r'^feedbacks$', FeedbackList.as_view(), name='feedbacks_list'),
	url(r'^feedbacks/(?P<feedback_pk>[0-9]+)/$', FeedbackUpdate.as_view(), 
			name='feedback_update'),
	url(r'^$', 'index', name='questions_index'),
)
