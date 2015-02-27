from django.db import models
import datetime

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')
    last_response_date = models.DateTimeField('last response date', null=True, blank=True)

    def __unicode__(self):
    	return self.question_text


class Choice(models.Model):
    question = models.ForeignKey(Question, related_name='choices')
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __unicode__(self):
    	return self.choice_text

    def save(self, *args, **kwargs):
        ''' On save, update timestamp on question '''
        self.question.last_response_date = datetime.datetime.today()
        self.question.save()
        return super(Choice, self).save(*args, **kwargs)


class Feedback(models.Model):
    question = models.ForeignKey(Question, related_name='feedbacks')
    feedback_text = models.CharField(max_length=500)
    pub_date = models.DateTimeField('date published')

    def __unicode__(self):
    	return self.feedback_text

    def save(self, *args, **kwargs):
        ''' On save, update timestamps '''
        if not self.id:
            self.pub_date = datetime.datetime.today()
        return super(Feedback, self).save(*args, **kwargs)

