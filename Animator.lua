-- written by github.com/swkeep

Animator = {
     next = false,
     current = {
          ped = nil,
          animDict = nil,
          anim = nil,
          facial = nil,
          animation_time = 0,
     },
     sync = {},
     async = {},
}

local function reset_next()
     Animator.next = false
end

local function update_timer(ped, data)
     Animator.current.animation_time = GetEntityAnimCurrentTime(ped, data.animDict, data.anim)
end

-- do not call this function use playanimation
local function playanimation_wrapper(ped, data)
     Animator:OverrideState(data.animDict, data.anim, data.facial, ped)
     if data.animDict then
          RequestAnimDict(data.animDict)
          while not HasAnimDictLoaded(data.animDict) do
               Wait(0)
          end
     end

     if data.anim then
          TaskPlayAnim(ped, data.animDict, data.anim, 8.0, 0, -1, data.flag or 1, 0, 0, 0, 0)
     end

     if data.facial then
          SetFacialIdleAnimOverride(ped, data.animDict, data.facial)
     end

     if data.timeout then
          if data.timeout.wait_until_next == true then
               repeat
                    update_timer(ped, data)
                    Wait(250)
               until Animator.next ~= false
               reset_next()
          end

          if data.timeout.after then
               Wait(data.timeout.after)
          end

          if data.timeout.clear.stop_playback then
               StopAnimPlayback(ped, 0, true)
          end

          if data.timeout.clear.stop_animation then
               StopAnimTask(ped, data.animDict, data.anim, 0)
          end

          if data.timeout.clear.normal then
               ClearPedTasks(ped)
          end

          if data.timeout.clear.force then
               ClearPedTasksImmediately(ped)
          end
     end
end

function Animator:OverrideState(animDict, anim, facial, ped)
     self.current.ped = ped
     self.current.animDict = animDict or nil
     self.current.anim = anim or nil
     self.current.facial = facial or nil
end

function Animator:GetCurrentAnimation()
     return self.current
end

function Animator:SetCurrentAnimationTime(time)
     SetEntityAnimCurrentTime(self.current.ped, self.current.animDict, self.current.anim, time)
     update_timer(self.current.ped, {
          animDict = self.current.animDict,
          anim = self.current.anim
     })
end

function Animator:SetCurrentAnimationSpeed(speedMultiplier)
     SetEntityAnimSpeed(self.current.ped, self.current.animDict, self.current.anim, speedMultiplier)
end

function Animator:goNext()
     self.next = true
end

function Animator.async.playanimation(ped, data)
     --@swkeep
     CreateThread(function()
          playanimation_wrapper(ped, data)
     end)
end

function Animator.sync.playanimation(ped, data)
     playanimation_wrapper(ped, data)
end

--- sequential animation
---@param ped any
---@param o table
function Animator:playanimations(ped, o)
     --@swkeep
     if o and type(o) == "table" then
          for _, list in pairs(o) do
               self.sync.playanimation(ped, list)
          end
     end
end
