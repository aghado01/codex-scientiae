# Sheets Evals

## Table of Contents

- [Sheets Rationales](#sheets-rationales)
- [Check :](#check-)
- [Strong Examples](#strong-examples)
- [Weak Examples](#weak-examples)
- [Grading Criteria](#grading-criteria)
- [Rating Rubric](#rating-rubric)
- [Submission Checklist](#submission-checklist)
      - [Use this checklist before every submission . Focus on document level quality .](#use-this-checklist-before-every-submission-focus-on-document-level-quality-)
    - [Fit and Confidence](#fit-and-confidence)
    - [Individual Rating](#individual-rating)
    - [Preferred Sheet](#preferred-sheet)
  - [Grading Criteria Checklist](#grading-criteria-checklist)
- [Correctness](#correctness)
- [Layout](#layout)
- [Formula usage](#formula-usage)
- [Style and aesthetics](#style-and-aesthetics)
    - [Overall](#overall)

---


Youʼll be working in the [Artifacts] Sheets Eval campaign in Feather.

  Before getting started, you must take the Sheets proficiency quiz . Everyone must take this quiz to continue working. The quiz is a Google form.

![In this image we can see a screenshot of a web page.](<SheetsEvals/imageFile1.png>)

# Sheets Rationales

![image 2](<SheetsEvals/imageFile2.png>)

READ MORE: Writing Rationales

  Follow the general guidance given in the Task Instructions . Here are some examples of Sheets specific rationales.

  Score each required sub-axis based on the sheetʼs actual quality in that area. Do not allow one axis to bleed into another.

![image 3](<SheetsEvals/imageFile3.png>)

Do not let one especially strong or weak aspect determine every score.

![image 4](<SheetsEvals/imageFile4.png>)

      If the prompt gives the model a template or example, evaluate whether the model faithfully followed it . In other words, do not assess style based on whether the template itself looks good .

  Rather, you should evaluate how well the model:

- Followed instructions.
- Used the provided template.
- Recreated the requested structure and styling.

- Adapted the template in a way that is faithful to the original application.

![image 5](<SheetsEvals/imageFile5.png>)

      Do not penalize the model for simply being provided poor quality inputs – such as an ugly template, messy source material, poor data/inputs, etc.

![image 6](<SheetsEvals/imageFile6.png>)

The goal is to judge instruction-following , not the quality of the materials the model was given.

# Check :

- How well requested amendments were implemented.
- Whether the rest of the template was reproduced accurately and consistently.

  Any deviations or reproduction errors should be treated as issues.

![image 7](<SheetsEvals/imageFile7.png>)

Note: Accurately reproducing templates is difficult for LLMs.

  The model does not directly edit the original template – it generates its own approximation using a code library. This often introduces formatting inconsistencies or structural errors.

![image 8](<SheetsEvals/imageFile8.png>)

# Strong Examples

  User Request: Create a basic spreadsheet Gantt chart for technology feature implementation project that's 6weeks discovery, 10wk design, 6wk development, and 4wk deployment; fill it in with project rows, owners, status, and visual timelines with cells.

- Response did a great job listing out a properly sequenced order for all the project tasks and dependencies, start and end dates, status, and total duration for each task over the stated timeline, and with clearly delineated phases as stated in the User Request.
- The use of automatic conditional formatting to highlight red/yellow/green for tasks that are late/delayed/on track is a great feature that will help quickly identify issues as the project progresses.
- The Excel formulas used to automatically fill in the Gantt chart task durations and mark identified Milestones allow the user to make minimal edits as the project changes, while dynamically updating the Gantt display in real-time.
- The Response lacks in the "Owner" column in that it only lists high-level roles like "Developer" or "Tester" and not named individuals, as will be required to properly execute the project.

![image 9](<SheetsEvals/imageFile9.png>)

# Weak Examples

  User Request: Create a basic spreadsheet Gantt chart for technology feature implementation project that's 6weeks discovery, 10wk design, 6wk development, and 4wk deployment; fill it in with project rows, owners, status, and visual timelines with cells.

- Response covered everything requested in the User Request.
- The formatting was good and colorful.
- Excel formulas were helpful to include.
- The “Ownerˮ column should have more info.

# Grading Criteria

  Grade each response for each of the following criteria:

| Grading Criteria | Description |
|------------------|-------------|
| Correctness | How well the workbook fulfills the userʼs request in a complete, accurate, and reliable way.<br><br>Look for:<br>- Coverage of the requested task and outputs.<br>- Accuracy of values, labels, logic, and workbook behavior.<br>- Whether instructions are followed correctly and completely.<br>- No misleading omissions or unnecessary additions.<br>- Whether the workbook is genuinely useful for the intended purpose.<br><br>Low scores: major errors, misunderstandings, missing required parts, unreliable outputs.<br><br>High scores: complete, accurate, reliable, clearly fulfills the task. |
| Layout | How headers, text, inputs, intermediate values, outputs, charts, and other elements are organized across the workbook. How clearly and logically the workbook is structured.<br><br>Look for:<br>- Clear separation of inputs, calculations, and outputs.<br>- Logical worksheet organization and flow.<br>- Consistent headers and labeling.<br>- Easy scanning and navigation.<br>- Whether the structure helps the user understand and use the workbook efficiently.<br><br>Low scores: disorganized, hard to follow, confusing placement, uneven structure.<br><br>High scores: clear flow, well-organized, easy to navigate, structured. |
| Formula usage | Formulas follow appropriate best practices, including avoiding hardcoding and magic numbers, staying simple to read, and using absolute and relative references appropriately for extension. How well formulas are used to support a correct, maintainable, and scalable workbook.<br><br>Look for:<br>- Use of formulas where they are needed and helpful.<br>- Avoidance of hardcoded values when references or formulas should be used.<br>- Appropriate use of absolute and relative references.<br>- Readable, simple, and maintainable formula construction.<br>- Whether formulas improve flexibility, reusability, and correctness.<br><br>Low scores: broken logic, unnecessary hardcoding, fragile formulas, confusing references.<br><br>High scores: robust, readable, well-structured formulas support extension and reuse. |
| Style and aesthetics | Appropriate number formats, fonts, borders and gridlines, row and column sizes, headers, color schemes, and overall polish. How polished, readable, and visually coherent the workbook feels.<br><br>Look for:<br>- Appropriate number and date formatting.<br>- Readable fonts, sizing, and emphasis.<br>- Effective use of borders, fills, and color.<br>- Consistent visual treatment across sheets.<br>- Overall polish without unnecessary clutter.<br><br>Low scores: messy, inconsistent, hard to read, visually unpolished.<br><br>High scores: clean, readable, polished, visually consistent. |
| Overall | How good is this workbook overall? How ready is it for real-world use? Can someone trust the outputs and maintain it going forward? How much revision is needed before it can be confidently shared or used?<br><br>Important: Overall is not a simple average. A major issue with correctness, formulas, or layout should significantly lower the rating. |

# Rating Rubric

  Use the full scale . Do not cluster scores in the middle.

| Rating | Description |
|--------|-------------|
| 1 - Very Poor | Severely broken or unusable.<br><br>Typical signs:<br>- Fails to address the task.<br>- Outputs are largely wrong or missing.<br>- Poor organization blocks understanding.<br>- Formula usage is absent, broken, or mostly hardcoded.<br>- Formatting makes the workbook difficult to read.<br>- Would need a near-total rebuild.<br>- Major errors make the workbook risky to use. |
| 2 - Poor | Major flaws that prevent normal use.<br><br>Typical signs:<br>- Key requirements are missing.<br>- Key calculations or formulas are incorrect.<br>- Inputs, calculations, and outputs are confusingly arranged.<br>- Poor layout or chart design creates real usability problems.<br>- Major repair would be needed before use. |
| 3 - Fair | Partly workable, but clearly below a solid standard.<br><br>Typical signs:<br>- Some useful material is present, but key weaknesses remain.<br>- Logic is only partially correct or hard to verify.<br>- Layout is inconsistent or inefficient.<br>- Formula usage is fragile or uneven.<br>- Workbook is salvageable, but needs meaningful revision. |
| 4 - Mixed | Adequate baseline, with clear pros and cons.<br><br>Typical signs:<br>- Core task is mostly addressed.<br>- Main outputs are present.<br>- Some formulas and formatting are reasonable.<br>- Rough edges are noticeable.<br>- Quality is uneven across sheets or axes.<br>- Acceptable for internal draft use, but not polished. |
| 5 - Good | Strong, usable workbook with a handful of fixable issues.<br><br>Typical signs:<br>- Correctness is solid and mostly complete.<br>- Layout is clear.<br>- Formulas are mostly appropriate and maintainable.<br>- Formatting is professional enough for use.<br>- Workbook needs moderate polish, not major restructuring. |
| 6 - Very good | High-quality workbook that is close to ready for real use.<br><br>Typical signs:<br>- Strong across nearly all axes.<br>- Calculations are reliable and easy to audit.<br>- Workbook structure is intuitive.<br>- Formulas support extension and reuse.<br>- Only minor weaknesses or polish issues remain. |
| 7 - Excellent | Outstanding workbook that fully satisfies the task with correct, trustworthy outputs.<br><br>Typical signs:<br>- Layout is clear, efficient, and user-friendly.<br>- Logic is clean, auditable, and maintainable.<br>- Formatting and charts are polished throughout.<br>- You could confidently use, share, or build on it as-is. |

# Submission Checklist

#### Use this checklist before every submission . Focus on document level quality .

We donʼt want a laundry list of issues , and youʼre not expected to catch everything. Focus on the key issues and explain why they matter .

- I have not already completed this task.
- I read the task prompt.
- I downloaded all responses and fully reviewed each one.
- I reviewed any provided sources.
- I validated factual claims via web search where applicable.
- I used the Grading Criteria and Rating Rubric when working on the task.
- I rated each response independently in chronological order before tackling the overall rating.
- Iʼve checked all responses for spelling, grammar and formatting errors and ensured each rationale is clearly and concisely written.

### Fit and Confidence

- I read the user request before claiming to check fit.
- The task sits within my domain expertise or clear comfort area.
- I'm confident in my ratings; if not, I did not submit.

### Individual Rating

- I rated all sheets on the 1-7 Quality Likert.
- I focused on overall sheet quality , not isolated moments.
- I wrote a clear and concise rationale for each, ideally with examples.
- I rated each sheet as independently as possible – one document's weakness didn't inflate the other's score.

### Preferred Sheet

- I selected a preferred document.
- I compared overall document quality.
- My rationale for the preference is informative and specific, not just "A is better." If there was a tie-break, I used my best judgement and provided a clear rationale.

## Grading Criteria Checklist

This is a summary of the issues noted in the Grading Criteria table. This list is NOT exhaustive, but should also serve as examples of things to consider.

# Correctness

- The workbook fully addresses the userʼs request.

- All required outputs are present.

- The workbook does not miss any important part of the task.

- The workbook follows the userʼs instructions completely.

- Values, labels, formulas, and outputs are accurate.

- The workbook logic is reliable and easy to verify.

- There are no misleading omissions.

- There are no unnecessary additions that distract from the task.

- The workbook is genuinely useful for its intended purpose.

# Layout

- Inputs, calculations, and outputs are clearly separated.

- Worksheets are organized in a logical order.

- The workbook has a clear flow from inputs to calculations to results.

- Headers and labels are clear, consistent, and meaningful.

- The workbook is easy to scan and navigate.

- Important information is not hidden, confusingly placed, or hard to find.

- The structure helps the user understand and use the workbook efficiently.

# Formula usage

- Formulas are used where they are needed.

- Values are not hardcoded where formulas or cell references should be used.

- There are no unexplained “magic numbersˮ in formulas.

- Absolute and relative references are used appropriately.

- Formulas are simple enough to read and audit.

- Formula logic is maintainable and scalable.

- Formulas can be extended or reused without breaking the workbook.

- There are no broken formulas, circular references, or fragile references.

# Style and aesthetics

- Number formats are appropriate for the data.

- Date, currency, percentage, and decimal formatting are applied correctly.

- Fonts, sizing, and emphasis are readable and consistent.

- Borders, fills, colors, and gridlines are used clearly and consistently.

- Row heights and column widths are appropriate.

- Charts, if included, are clearly labelled and easy to interpret.

- The workbook looks polished without unnecessary clutter.

- Formatting is consistent across sheets.

### Overall

- The workbook is ready for real-world use.
- A user can trust the outputs.
- Someone else could maintain or update the workbook later.
- The workbook would not require major revision before being shared or used.
- Any major issue with correctness, formulas, or usability has been fixed before submission.
- The final workbook is as complete, reliable, and polished as the task allows.

