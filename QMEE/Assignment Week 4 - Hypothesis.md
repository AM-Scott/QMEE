Week 4 assignment 2 – Statistical Philosophy – Hypothesis about my data

The main hypothesis about my data that I wish to test has to do with whether there is "meaningful" divergence between the two selection treatment groups (i.e. "Up", which is being selected for increased sociability, and "Down", which is being selected for decreased sociability). Specifically, I hypothesized that the "Up" selection group should be more sociable than the "Down", however there should be no difference at generation 1 (since all selection lineages are derived from the same starting population), and instead the difference should increase over time.

**BMB**: "meaningful" is good, it would be good to dig deeper into what you mean by that.  Are you just trying to avoid talking about statistical significance? What would be your reasons for believing this would or wouldn't be the case? (e.g.: you're doing artificial selection, so the response *should* occur unless there's (1) insufficient genetic diversity; (2) genetic constraints; (3) your selection regime is inefficient for some reason; (4) ??? [too much noise of some other sort to detect an effect?])

I have planned to use a generalized linear mixed model to model the selection data. I plan to use generalized rather than general because I expect the residuals of the response variable, the "Aggregation Index", to follow a gamma distribution - most of the observations in the low end of the scale (between 1 and 2), with a long positive tail up to the upper bound of the scale at 16.

**BMB**: in this case it's not exactly "residuals of the response variable", it's actually the **conditional distribution** of the response (we'll discuss this in class).  You could also log-transform the response and use a linear mixed model (e.g. google "Gamma lognormal GLM" for some discussions ...)

I plan to set up a model like this (in glmer format):

Aggregation_Index ~ 1 + Treatment*Generation + (1 | Lineage) + (1 | Block) + (1 | Dish)

Overall, I can look at the main effect of treatment as an indication of the divergence, but this may be misleading as I expect there to be very little divergence in the early generations. A better test will be to look at whether the interaction parameter between Treatment and Generation is significant. This can be accomplished by looking at the estimate and confidence intervals of the interaction, as well as (or maybe instead of?) a likelihood ratio test that compares the model with the interaction to a null model without the interaction (in order to calculate a p-value, which will likely be necessary if we have hopes of publishing in our field).

**BMB**: there's really nothing wrong with p-values used correctly/in context. I agree that either the slope difference (= treatment-generation interaction), or maybe the difference at the *final* time, is a sensible thing to test.

I plan to include other variables such as lineage, test block, and test dish as random factors in the model. I think this makes sense for lineage as the 4 replicate lineages per selection treatment are effectively "subject IDs", however I am a bit unsure about the block and dish variables - there is no underlying biological significance with respect to the block that flies were tested in or the dish that was used, but these may have contributed some amount of variation to the data, so I feel that assigning them as "random" variables is more appropriate. I would definitely like to learn more about this as I feel that I don't have as clear a grasp over random effects and mixed modelling in general.

**BMB**: yes, in general these would be reasonable as random effects. We will go over the distinction between a *random* variable (an effect for which you want to estimate variation across groups, rather than differences between specific pairs of groups) and a *nuisance* variable (a variable that's not of direct biological interest but should be taken into account in the analysis, either for clarity or allowing for non-independence)

score: 2.75
