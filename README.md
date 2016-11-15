# Q-Learning Bot: Simple Trade Game

I wrote this to explore [Q-learning](https://en.wikipedia.org/wiki/Q-learning), the principal component of DeepMind. It has a trivial state machine which observes the best options available in its current state, randomly choosing a winner if there is a tie, and then moves to another state. It then corrects its estimation of that transition and continues. This toy does not ascribe values to end-states, but rather associates a score to each *transition* point. This was primarily by accident although has the interesting side effect of experimentally learning trade routes. If one town is better to visit *after* another, this setup will discover that and perform the route. A simpler system that only looked at the town's score overall might make poor trade decisions, as it might not have cargo that town needs.

It is built to run on the [Torch7](http://torch.ch) platform.

## Remarks

I have noticed that if Uncertain has an initially positive transaction, the bot will incorporate that as part of the trade route seemingly forever. If the initial transaction is negative, that town will never again be visited in the current model. This mimics the human *anchoring effect*, where first impressions essentially make or break an agent's future interactions with another agent regardless of output potential. Even if the negative output potential is slim, a single bad data-point at first is sufficient to prevent future relations.

## Future work

I would like towns to store their base value, which would be incorporated with transitions through bayesian logic. This would allow the bot to consider going to a known-good town more favorably regardless of its current location, while still being able to learn whether or not a given state change was especially unproductive.

I would also like to use a tournament selection for state changes. Good choices should be weighted above all else, however unknowns and bad choices should be revisited *rarely* just in case there lies a better route--the current model is likely to create a small loop and never bother with other towns at all.

## Curiosity

I would like to see if there is a way to have multiple ships running, which then trade information whenever they run in to one another. Perhaps the relative wealth of two tradesman can be used to moderate the exchange, so a more successful merchant's advice will create a larger change in state estimates. This would allow multiple ships of the same organization to train each other in good routes, so multiple ships can explore a larger section of the space. This could lead to all ships eventually adopting only a single route, which might be suboptimal for the entire group--dealing with that is something that has to be done when it comes up however.
