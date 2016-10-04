# -*- coding: utf-8 -*-
'''TO-DO: Write a description of what this XBlock is.'''
from __future__ import division

import pkg_resources
#import uuid
import re
import random
import textwrap


from xblock.core import XBlock
from xblock.fields import Scope, String, Integer, Boolean, Float
from xblock.fragment import Fragment
#from django.conf.urls import url
#from django.conf import settings
from django.template import Context, Template
#from xmodule.contentstore.content import StaticContent

class StsbSimXBlock(XBlock):
    '''
    Icon of the XBlock. Values : [other (default), video, problem]
    '''
    icon_class = "other"
    has_score = True
    '''
    Fields are defined on the class.  You can access them in your code as
    self.<fieldname>.
    '''
    display_name = String(
        display_name="Display Name",
        help="This name appears in the horizontal navigation at the top of the page.",
        scope=Scope.settings,
        default="MSC Simulation"
    )
    weight = Float(
        display_name="Maximum weight",
        help="This is the maximum score that the user receives when he/she successfully completes the problem",
        scope=Scope.settings,
        default=1
    )
    min_percent = Float(
        display_name="Minimum score in percents if maximum weight",
        help="This is the minimum score that the user receives when he/she successfully completes the problem",
        scope=Scope.settings,
        default=50
    )
    max_attempts = Integer(
        display_name="Max number of attempts",
        help="If amount of attempts is above this number student will get minimal score",
        scope=Scope.content,
        default=5
    )
    data = String(
        help="Problem data",
        scope=Scope.content,
        default=textwrap.dedent('''
            <M lbl="From A to B" w="100" icon="a12">
                <M lbl="Simple" w="80" icon="a12">
                    <A lbl="Simple" w="80" id="9" txt="SMPL" mc="a12" icon="a12"/>
                </M>
                <M lbl="Bold" w="80" icon="b12">
                    <A lbl="Bold" w="80" id="10" txt="BLD" mc="b12" icon="b12"/>
                </M>
                <M lbl="Process" w="80" icon="b12">
                    <A lbl="Process" w="80" id="13" txt="PRC" mc="p12" icon="b12"/>
                </M>
                <M lbl="State" w="80" icon="s12">
                    <A lbl="State" w="80" id="14" txt="STT" mc="s12" icon="s12"/>
                </M>
            </M>
            <M lbl="From C to B" w="100" icon="a32">
                <A lbl="Message" w="110" id="19" txt="MSG" mc="a32"icon="a32"/>
            </M>
            <M lbl="Blocks" w="80">
                <B lbl="A" w="110" id="bla" txt="Block A"/>
                <B lbl="B" w="110" id="blb" txt="Block B"/>
                <B lbl="C" w="110" id="blc" txt="Block C"/>
            </M>
            <BLOCKS>
                <BLOCK lbl="Block type" x="100" y="100" w="100" h="30" c="0x027BF4" />
                <BLOCK lbl="Block type" x="300" y="100" w="100" h="30" c="0x027BF4" />
                <BLOCK lbl="Block type" x="500" y="100" w="100" h="30" c="0x027BF4" />
            </BLOCKS>
            <LINES y="150" x1="150" x2="350" x3="550"/>
        '''))
    question = String(
        help="Main task",
        scope=Scope.content,
        default="?"
    )
    answer = String(
        display_name='Correct answer',
        help='Looks like [(1|id6|"manual input")|(second_variant)]',
        scope=Scope.content,
        default="[(bla|blb|blc|9|19)]"
    )
    bgd_url = String(
        help="URL for background image",
        scope=Scope.content,
        default=""
    )
    nblocks = Integer(
        help="Number of blocks",
        scope=Scope.content,
        default=3
    )
    attempts = Integer(
        display_name="Number of attempts",
        help="Amounts of attempts student used before answer correct",
        scope=Scope.user_state,
        default=0
    )
    current_answer = String(
        help="Answer gived by user",
        scope=Scope.user_state,
        default="()"
    )
    finish = Boolean(
        help="Finished",
        scope=Scope.user_state,
        default=False
    )
    score = Boolean(
        help="Users's score",
        scope=Scope.user_state,
        default=1
    )
    restart = Boolean(
        help="Restarted",
        scope=Scope.user_state,
        default=False
    )
    '''
    Util functions
    '''
    def load_resource(self, resource_path):
        '''
        Gets the content of a resource
        '''
        resource_content = pkg_resources.resource_string(__name__, resource_path)
        #return data.decode("utf8")
        return unicode(resource_content)

    def render_template(self, template_path, context={}):
        '''
        Evaluate a template by resource path, applying the provided context
        '''
        template_str = self.load_resource(template_path)
        return Template(template_str).render(Context(context))

    '''
    Main functions
    '''
    def student_view(self, context=None):
        '''
        The primary view of the StsbSimXBlock, shown to students
        when viewing courses.
        '''
        score_string = ('({0}/{1})'.format(self._get_score(0), #use 0 to get score on net attempt
            int(self.weight))+'баллов') if self.weight else ''
        context = {
            'title': self.display_name,
            'swfUrl': self._get_swf_crutch(),
            'oldUrl': self.runtime.local_resource_url(self, 'public/swf/sim.swf'),
            'data': self.data,
            'question': self.question,
            #'uniqueId': str(random.random()).replace('.','_'),
            #'uniqueId': str(self.scope_ids.usage_id).replace('.','_'),
            'uniqueId': 's'+self._get_unique_id(),
            #'bgdUrl': '36'+self.runtime.local_resource_url(self, 'public/swf/sim.swf'),
            'bgdUrl': self.bgd_url,
            #StaticContent.get_base_url_path_for_course_assets(self.location),
            #settings.COURSE_KEY_PATTERN+
            'finish': 1 if self.finish else 0,
            'currentAnswer': self.current_answer,
            'score': self._cute_float(self._get_score(1 if self.finish else 0)),
            'maxScore': self._cute_float(self.weight) + ' баллов',
            'attempts': self.attempts,
            'maxAttempts': str(self.max_attempts) + '+ попыток',
        }
        html = self.render_template("static/html/stsbsim_view.html", context)

        frag = Fragment(html)
        frag.add_css(self.load_resource("static/css/stsbsim.css"))
        frag.add_javascript(self.load_resource("static/js/src/stsbsim_view.js"))
        #frag.add_resource(self.runtime.local_resource_url(self, "static/swf/sim.swf"), 'application/x-shockwave-flash', )
        frag.initialize_js('stsbsimXBlockInitView')
        return frag


    def studio_view(self, context=None):
        '''
        The secondary view of the StsbSimXBlock, shown to teachers
        when editing the XBlock.
        '''
        context = {
            'title': self.display_name,
            'weight': self.weight,
            'min_percent': self.min_percent,
            'max_attempts': self.max_attempts,
            'data': self.data,
            'answer': self.answer,
            'question': self.question,
            'bgdUrl': self.bgd_url,
        }
        html = self.render_template('static/html/stsbsim_edit.html', context)
        
        frag = Fragment(html)
        frag.add_javascript(self.load_resource("static/js/src/stsbsim_edit.js"))
        frag.initialize_js('stsbsimXBlockInitEdit')
        return frag

    def get_score(self):
        """
        Access the problem's score
        """
        return self._get_score()

    def max_score(self):
        """
        Access the problem's max score
        """
        return self.weight

    # TO-DO: change this handler to perform your own actions.  You may need more
    # than one handler, or you may not need any handlers at all.

    @XBlock.json_handler
    def save_data(self, data, suffix=''):
        '''
        The saving handler.
        '''
        self.display_name = data['title']
        self.weight = data['weight'].replace(',','.')
        self.min_percent = data['min_percent'].replace(',','.')
        self.max_attempts = data['max_attempts']
        self.question = data['question']
        d = data['data']
        if (d.find('label=')>=0): #fix for old data format
            d = d.replace('txt=','lbl=')
            d = d.replace('label=','txt=')
        self.data = d
        self.answer = data['answer']
        self.bgd_url = data['bgd_url']
        self.nblocks = data['data'].lower().count('<block ')
        return {
            'result': 'success',
        }
    def _checkAnswer(self, answ):
        if(self.restart != True):
            self.current_answer = answ;
            self.attempts += 1; 
        answer = answ[1:-1].split('|')
        variants = re.findall('\(.*?\)',self.answer)
        best = 0;
        bestId = -1;
        bestErrors =[]
        t = []
        finish = 0
        for v in variants:
            v = v[1:-1].split('|')
            curRecord = 0
            errors = []
            fail = False
            arrowFail = False
            for k2, item in enumerate(answer):
                t.append([len(v),k2])
                item = item
                isArrow = k2 >= self.nblocks
                if(len(v) <= k2 or v[k2] != item):   #to many answer parts or answer part is wrong
                    fail = True
                    errors.append(0)
                    if isArrow:
                        arrowFail = True
                else:                               #correct answer part
                    if isArrow:     #its arrow
                        if arrowFail:
                            errors.append(0)
                        else:
                            errors.append(1)
                            curRecord+=1
                    else:            #its block
                        errors.append(1)
                        curRecord+=1
            if(fail == False):
                if(len(v) == len(answer)):
                    if(self.restart != True):
                        self.finish = True
                        self.runtime.publish(self, "grade", {"value": self._get_score(), "max_value": 1.0 })#self._get_score()
                    finish = 1
            if(best == 0 or curRecord > best):
                best = curRecord
                bestErrors = errors
        return {"finish": finish, "result": bestErrors}

    @XBlock.json_handler
    def get_data(self, data, suffix=''):
        '''
        This is old function for js getting init data
        but now we dont use it and send init data as attributes of embed obj
        '''
        return {"data": self.data, "question": self.question, "bgd_url": self.bgd_url}

    @XBlock.json_handler
    def get_check(self, data, suffix=''):
        check = self._checkAnswer(data['answer'])
        return {"finish": check['finish'], "score": self._cute_float(self._get_score(1 if check['finish']==1 else 0)),  "attempts": self.attempts, "result": check['result']}
        
    def _cute_float(self, x):
        return ('%f' % x).rstrip('0').rstrip('.')

    def _get_unique_id(self):
        try:
            unique_id = self.location.name.replace('.','_')
        except AttributeError:
            # workaround for xblock workbench
            unique_id = 'stsbsim'+str(random.random()).replace('.','_')
        return unique_id

    def _get_score(self, delta=1):
        #return self.weight*(1 - (self.attempts-1)/self.max_attempts*(1 - self.min_percent/100))
        if self.min_percent>=100:
            return self.weight
        return self.weight*(1 - min(self.attempts-delta, self.max_attempts)/self.max_attempts*(1 - (self.min_percent)/100))

    def _get_swf_crutch(self):
        try:
            swf = str(self.runtime.local_resource_url(self, 'public/swf/sim.swf'))
            swf = swf.replace('//localhost/','/')   #dont know why but our lms server generates "//localhost/xblock....." 
            if(swf.find('/static/') > -1):
                swf = '/xblock/resource/stsbsim/public/swf/sim.swf'
        except:
            swf = '/xblock/resource/stsbsim/public/swf/sim.swf'
        return swf

    @staticmethod
    def workbench_scenarios():
        '''A canned scenario for display in the workbench.'''
        return [
            ("StsbSimXBlock",
             """<stsbsim/>
             """),
            ("Multiple StsbSimXBlock",
             """<vertical_demo>
                <stsbsim/>
                <stsbsim/>
                </vertical_demo>
             """),
        ]
