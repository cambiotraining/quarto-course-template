local number_exercises = false
local hide_answers = false

function Meta(meta)
  -- Access metadata with hyphens using bracket notation
  if meta["number-exercises"] and meta["number-exercises"] == true then
    number_exercises = true
  end

  if meta["hide-answers"] and meta["hide-answers"] == true then
    hide_answers = true
  end
end

local exercise_counter = 0  -- Global counter for exercises

function Div(div)
  if div.classes:includes("callout-exercise") then
    exercise_counter = exercise_counter + 1
    local exercise_number = number_exercises and ("Exercise " .. exercise_counter) or "Exercise"

    if div.content[1] ~= nil and div.content[1].t == "Header" then
      local title = pandoc.utils.stringify(div.content[1])
      div.content:remove(1)  -- Remove the original header from content
      local final_title = number_exercises and exercise_number .. " - " .. title or title
      return quarto.Callout({
        type = "exercise",
        content = { div },
        title = final_title,
        icon = false,
        collapse = false
      })
    else
      return quarto.Callout({
        type = "exercise",
        content = { div },
        title = exercise_number,
        icon = false,
        collapse = false
      })
    end
  end

  -- Remove callout-answer divs if hide_answers is true
  if div.classes:includes("callout-answer") then
    if (hide_answers and div.attributes["hide"] ~= "false") or div.attributes["hide"] == "true" then
        return pandoc.RawBlock('html', '<div hidden></div>')
    else
      return quarto.Callout({
        type = "answer",
        content = { div },
        title = "Answer",
        icon = false,
        collapse = true
      })
    end
  end

  if div.classes:includes("callout-hint") then
    return quarto.Callout({
      type = "hint",
      content = { div },
      title = "Hint",
      icon = false,
      collapse = true
    })
  end
end

return {
  { Meta = Meta },
  { Div = Div }
}
