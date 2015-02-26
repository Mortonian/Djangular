from django.db import models

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    def __unicode__(self):
    	return self.question_text


class Choice(models.Model):
    question = models.ForeignKey(Question, related_name='choices')
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __unicode__(self):
    	return self.choice_text


class Feedback(models.Model):
    question = models.ForeignKey(Question, related_name='feedbacks')
    feedback_text = models.CharField(max_length=500)
    pub_date = models.DateTimeField('date published')

    def __unicode__(self):
    	return self.feedback_text

