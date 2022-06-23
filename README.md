# simple-animator

simple fivem animation lib for developers

- to go to next animation after using wait_until_next you need to call

```lua
Animator:goNext()
```

- example:

```lua
     local anim = {
          {
               animDict = 'anim@scripted@payphone_hits@male@',
               anim = 'fxfr_phl_1_intro_male',
               facial = 'fxfr_phl_1_intro_male_facial',
               timeout = {
                    wait_until_next = true,
                    clear = {
                         --stop_playback = true,
                         --stop_animation = true,
                         -- normal = true,
                         force = true
                    }
               },
               flag = 1,
          },
          {
               animDict = 'anim@scripted@payphone_hits@male@',
               anim = 'exit_left_male',
               facial = nil,
               timeout = {
                    after = 4500,
                    clear = {
                         force = true
                    }
               },
               flag = 0,
          }
     }
     Animator.playanimations(ped, anim)

     -- just one animation
     Animator.async.playanimation(ped, anim[1])
     Animator.sync.playanimation(ped, anim[1])

```
