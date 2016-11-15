
rng = torch.Generator()

score = 0

function go_england()
   --print 'went to england'
   score = torch.random(rng, 1,3)
   here = states['england']
end

function go_uncertainty()
   --print 'went to uncertainty'
   score = torch.random(rng, -5,10)
   here = states['uncertainty']
end

function go_china()
   --print 'went to china'
   score = torch.random(rng, 3,6)
   here = states['china']
end

here = nil
states = {
   ["china"] = {
      ["actions"] = {
	 ["england"] = {
	    ["estimate"] = 0,
	    ["implement"] = go_england
	 },
	 ["uncertainty"] = {
	    ["estimate"] = 0,
	    ["implement"] = go_uncertainty
	 }
      }
   },
   ["england"] =  {
      ["actions"] = {
	 ["uncertainty"] = {
	    ["estimate"] = 0,
	    ["implement"] = go_uncertainty
	 },
	 ["china"] = {
	    ["estimate"] = 0,
	    ["implement"] = go_china
	 }
      }
   },
   ["uncertainty"] = {
      ["actions"] = {
	 ["england"] = {
	    ["estimate"] = 0,
	    ["implement"] = go_england
	 },
	 ["china"] = {
	    ["estimate"] = 0,
	    ["implement"] = go_china
	 }
      }
   }
}

learning_rate = 0.1
discount = 0.1
function q(old, reward, estimate)
   return old + learning_rate * ((reward + discount * estimate) - old)
end

function find_best_option(list)
   local best_score = 0
   local options = {}
   for k, v in pairs(list) do
      if #options == 0 then
	 best_score = v.estimate
	 options = {k}
      elseif v.estimate == best_score then
	 -- this is a tie, add options
	 table.insert(options, k)
      elseif v.estimate > best_score then
	 -- mark superior option
	 best_score = v.estimate
	 -- clear ties
	 options = {k}
      end
   end
   return options[torch.random(rng, 1, #options)], best_score
end

here = states['england']
for i = 1, 100 do
   -- select next action
   best, best_score = find_best_option(here.actions)
   -- execute
   action = here.actions[best]
   action.implement()
   action.estimate = q(action.estimate, score, action.estimate)
   print(best, score, action.estimate)
end
