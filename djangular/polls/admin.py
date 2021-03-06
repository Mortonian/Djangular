from django.contrib import admin
from polls.models import Choice, Question, Feedback


class ChoiceInline(admin.StackedInline):
    model = Choice
    extra = 3


class FeedbackInline(admin.StackedInline):
    model = Feedback
    extra = 1


class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['question_text']}),
        ('Date information', {'fields': ['pub_date'],
                              'classes': ['collapse']}),
    ]
    inlines = [ChoiceInline, FeedbackInline]

admin.site.register(Question, QuestionAdmin)