
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(highcharter)


header <- dashboardHeader(title = "Smogon Stats Viz")


sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Usage Stats", tabName = "usage", icon = icon("chart-bar")),
        menuItem("Usage Comparison", tabName = "usage_2", icon = icon("table")),
        menuItem("Moveset", tabName = "moveset", icon = icon("user-cog")),
        menuItem("FAQ", tabName = "FAQ", icon = icon("question"))
    )
)


body <- dashboardBody(
    tabItems(
        tabItem(
            tabName = "usage",
            fluidRow(
                box(width = 2,
                    title = "Select Month:",
                    airMonthpickerInput(
                        inputId = "month_select",
                        value = format(Sys.Date()-31, "%Y-%m-%d"),
                        label = " ",
                        minDate = "2014-11-01",
                        maxDate = format(Sys.Date()-31, "%Y-%m-%d"),
                        minView = "months"
                        )
                    ),
                box(width = 2,
                    title = "Select Gen:",
                    selectInput("gen_select", label = " ", choices = gen_vec),
                    ),
                box(width = 2,
                    title = "Select Tier/Format:",
                    selectInput("format_select", label = " ", choices = formats),
                    ),
                box(width = 3,
                    title = "Select Skill Weighting:",
                    selectInput("skill_weighting_select",
                                label = "See the FAQ if you don't know what this is",
                                choices = skill_ranking)
                    ),
                box(width = 3,
                    title = "Select Usage Weighting:",
                    selectInput("usage_weighting_select",
                                label = "See the FAQ if you don't know what this is",
                                choices = usage_weighting)
                    )
            ),
            fluidRow(
                valueBoxOutput("common_type"),
                valueBoxOutput("most_used_mon"),
                valueBoxOutput("total_battles")
                ),
            fluidRow(
                box(
                      width = 12,
                      title = "Usage by Type",
                      highchartOutput("usage_plot"),
                      textOutput("usage_plot_note")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Usage Table",
                    DT::dataTableOutput("usage_table"),
                    style = "height:600px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x:scroll;")
                )
            ),
        tabItem(
            tabName = "usage_2",
            fluidRow(
                box(width = 2,
                    title = "Select Month 1:",
                    airMonthpickerInput(
                        inputId = "month_select_2a",
                        value = format(Sys.Date()-31, "%Y-%m-%d"),
                        label = " ",
                        minDate = "2014-11-01",
                        maxDate = format(Sys.Date()-31, "%Y-%m-%d"),
                        minView = "months"
                        )
                    ),
                box(width = 2,
                    title = "Select Gen 1:",
                    selectInput("gen_select_2a", label = " ", choices = gen_vec),
                    ),
                box(width = 2,
                    title = "Select Tier/Format 1:",
                    selectInput("format_select_2a", label = " ", choices = formats),
                    ),
                box(width = 3,
                    title = "Select Skill Weighting 1:",
                    selectInput("skill_weighting_select_2a",
                                label = "See the FAQ if you don't know what this is",
                                choices = skill_ranking)
                    ),
                box(width = 3,
                    title = "Select Usage Weighting:",
                    selectInput("usage_weighting_select_2",
                                label = "See the FAQ if you don't know what this is",
                                choices = usage_weighting)
                    )
            ),
            fluidRow(
                box(width = 2,
                    title = "Select Month 2:",
                    airMonthpickerInput(
                        inputId = "month_select_2b",
                        value = format(Sys.Date()-31, "%Y-%m-%d"),
                        label = " ",
                        minDate = "2014-11-01",
                        maxDate = format(Sys.Date()-31, "%Y-%m-%d"),
                        minView = "months"
                        )
                    ),
                box(width = 2,
                    title = "Select Gen 2:",
                    selectInput("gen_select_2b", label = " ", choices = gen_vec),
                    ),
                box(width = 2,
                    title = "Select Tier/Format 2:",
                    selectInput("format_select_2b", label = " ", choices = formats),
                    ),
                box(width = 3,
                    title = "Select Skill Weighting 2:",
                    selectInput("skill_weighting_select_2b",
                                label = "See the FAQ if you don't know what this is",
                                choices = skill_ranking)
                    )
            ),
            fluidRow(
                box(width = 12,
                    title = "Usage Comparison")
            )
          ),
        tabItem(
            tabName = "moveset",
            fluidRow(
                box(width = 2,
                    title = "Select Month:",
                    airMonthpickerInput(
                        inputId = "month_moveset",
                        value = format(Sys.Date()-31, "%Y-%m-%d"),
                        label = " ",
                        minDate = "2014-11-01",
                        maxDate = format(Sys.Date()-31, "%Y-%m-%d"),
                        minView = "months"
                        )
                    ),
                box(width = 2,
                    title = "Select Gen:",
                    selectInput("gen_moveset", label = " ", choices = gen_vec),
                    ),
                box(width = 2,
                    title = "Select Tier/Format:",
                    selectInput("format_moveset", label = " ", choices = formats),
                    ),
                box(width = 3,
                    title = "Select Skill Weighting:",
                    selectInput("skill_weighting_moveset",
                                label = "See the FAQ if you don't know what this is",
                                choices = skill_ranking)
                    ),
                box(width = 3,
                    title = "Select A Pokemon:",
                    selectInput("pokemon_moveset",
                                label = " ",
                                choices = NULL)
                    )
                  ),
          fluidRow(
              box(width = 6,
                  title = "Abilities",
                  highchartOutput("hc_abil_plot"),
                  style = "height:450px;"
                  ),
              box(width = 6,
                  title = "Ability Table",
                  DT::dataTableOutput("dt_abil_table"),
                  style = "height:450px;
                           width:auto;"
                  )
                ),
          fluidRow(
              box(width = 6,
                  title = "Top 10 Items Used",
                  highchartOutput("hc_item_plot"),
                  style = "height:450px;"
                  ),
              box(width = 6,
                  title = "Item Table",
                  DT::dataTableOutput("dt_item_table"),
                  style = "height:450px;
                           width:auto;
                           overflow-y:scroll;
                           overflow-x:scroll;"
                  )
                ),
            fluidRow(
                box(width = 6,
                    title = "Top 10 Moves Used",
                    highchartOutput("hc_move_plot"),
                    style = "height:450px;"
                    ),
                box(width = 6,
                    title = "Move Table",
                    DT::dataTableOutput("dt_move_table"),
                    style = "height:450px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x:scroll;"
                    )
                  ),
            fluidRow(
                box(width = 6,
                    title = "Top 10 Natures, IV/EV Spreads Used",
                    highchartOutput("hc_spreads_plot"),
                    textOutput("spreads_plot_note"),
                    style = "height:450px;"
                    ),
                box(width = 6,
                    title = "Spreads",
                    DT::dataTableOutput("dt_spread_table"),
                    style = "height:450px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x:scroll;"
                    )
                  ),
            fluidRow(
                box(width = 6,
                    title = "Top 10 and Bottom 5 Teammates",
                    highchartOutput("hc_teammate_plot"),
                    style = "height:450px;"
                    ),
                box(width = 6,
                    title = "Teammate Table",
                    DT::dataTableOutput("dt_teammate_table"),
                    style = "height:450px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x:scroll;"
                    )
                  ),
            fluidRow(
                box(width = 6,
                    title = "Top 10 and Bottom 5 Checks/Counters",
                    highchartOutput("hc_checks_plot"),
                    style = "height:450px;"
                    ),
                box(width = 6,
                    title = "Checks and Counters",
                    DT::dataTableOutput("dt_checks_n_counters"),
                    style = "height:450px;
                             width:auto;
                             overflow-y:scroll;
                             overflow-x:scroll;"
                    )
                  )
            ),
        tabItem(
            tabName = "FAQ",
            fluidRow(
                box(width = 12,
                    title = "Why is the data not showing?",
                    HTML("If the data is not showing, that may be because:
                          <br>
                          <ul>
                            <li>You picked a date in the future</li>
                            <li>If you picked last month’s date, the stats
                            have not been released yet (they’re usually
                            released a few days after the end of the month)
                            </li>
                            <li>You selected a format or Gen that did not
                            exist for that particular month (e.g. Gen 1 PU,
                            or Gen 8 OU in Oct 2017)</li>
                            <li>I screwed up – See below on letting me know
                            </li>
                          </ul>")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Why is a particular tier/format not showing in the
                    drop down menu?",
                    HTML("<p>Unfortunately, the tier/format list is manually
                    entered rather than retrieved from the Smogon Stats
                    database. It was simply a lot easier to do it this way
                    while having the text show up nicely in the drop-down,
                    particularly since there are so many different formats.</p>

                    <p>However, this means that I may have missed some formats,
                    particularly the more obscure ones that were present only
                    for a couple of months or were phased out long ago, and
                    they would not show up in the drop-down.</p>
                    <p>Let me know if this is the case.</p>")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "What is the Skill Weighting?",
                    HTML("<p>The skill weighting refers to players’ skill
                    rating for a tier. Though the numbers look similar, this
                    weighting is different from your ladder rating. It is used
                    in several places by Smogon, from the publishing of
                    statistics to deciding what Pokemon are usable at each tier.
                    Here, selecting a given skill weighting retrieves the file
                    that treats that weighting as the baseline (see question 7
                    in the thread linked below). In general, the higher the
                    skill weighting chosen, the more competent the teams/players
                    included in the dataset.</p>

                    <p>Having established how we use the skill ratings, further
                    questions about what it implies for the stats presented are
                    more competently answered by Antar, who wrote the scripts
                    processing the battle logs into the data we see. He provides
                    a great FAQ in <a href = 'https://bit.ly/39KZVrN'>this
                    post</a>. Below, I quote some of the portions more pertinent
                    for our purposes. </p>


                    <strong>Some rules of thumb on how to think about the
                    different skill weightings:</strong>
                    <blockquote style = \"font-size:14px\">
                    <ul>
                      <li>Baseline-0 (unweighted) stats represent everything in
                      the format, no matter how lulzy the player or team. This
                      is what you'd expect to encounter if we stopped doing
                      matchmaking.</li>
                      <li>1500 (no extension) stats represents what the average
                      player in the metagame sees. Since Showdown's playerbase
                      is more than just Smogonites, this is considerably
                      \"below\" what the average person reading this thread
                      sees.</li>
                      <li>1630 (1695 for OU) stats represent \"standard\" stats,
                      what the typical competitive player should see and be
                      prepared for.</li>
                      <li>1760 (1825 for OU) stats represent \"1337\" stats, what
                      the best-of-the-best in the metagame are doing. To some
                      extent, this is what all players should strive to be doing,
                      but there are some Pokemon and strategies that are
                      difficult to pull off and might require a greater amount
                      of skill than the typical competitive player possesses.
                      </li>
                    </ul>
                    </blockquote>
                    <strong>Why are the OU stats for 1695 and 1825 instead of
                    for 1630 and 1760?</strong>
                    <blockquote style = \"font-size:14px\">
                    OU, aka \"Standard,\" is, well, our standard tier. It
                    sees more battles than any other format and has the largest
                    playerbase (second only to randbats). It also has the
                    smallest fraction of \"competitive players\" of all
                    non-random formats, due to its prominence and easy
                    accesibility. Since our rating systems are percentile-based
                    (that is, a rating of x roughly corresponds to being better
                    than y% of the ladder, rather than indicating that the
                    player is the nth best in the metagame), that means that
                    it's a lot easier to get a rating of 1630 in OU than it is
                    in UU or LC. Because of that, and because OU has a larger
                    pool of battles to work with, we can up our baseline to
                    1695 for the \"standard\" stats. Similarly, while 1760 is
                    the usual value we use for \"elite\" stats (the best of the
                    best), the number that works better for OU is 1825.
                    </blockquote>
                    <strong>For the curious, more on the Skill Weighting:
                    </strong>
                    <blockquote style = \"font-size:14px\">
                    Every player on Pokemon Showdown has a skill rating for each
                    metagame they participate in. This rating--which is different
                    from your ladder score--is calculated using an algorithm
                    called Glicko and consists of an estimated skill value R and
                    an uncertainty in that estimate RD. Based on these two values,
                    we calculate the likelihood that a given player has a
                    \"true\" skill value above a certain baseline (the
                    conventional baseline was 1500, corresponding to the
                    \"average\" player). For more about ratings,
                    <a href = 'https://bit.ly/2XcM2jq'>read here</a>. For more
                    about weightings, <a href = 'https://bit.ly/34b5G0X'>read
                    here</a>. Note that, starting with the May [2014] stats, if a
                    player has an RD greater than 100, and the baseline is above
                    1500, then their team is not counted in the stats. Note
                    further that it typically only takes about 5 or 6 battles to
                    get one's RD below 100.”
                    </blockquote>")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "What is the Usage Weighting?",
                    HTML("<p>Usage, Raw, and Real refer to different ways of
                    computing the usage of a Pokemon in the tier. For the bar
                    graph in the usage stats, the app simply sums the usage
                    percentages across all Pokemon of each type, counting
                    dual-type Pokemon twice, once for each type it belongs to.
                    Percentages give a proportion, whereas \"Raw\" and \"Real\"
                    give absolute numbers. This is not possible for Usage given
                    how it is computed. Details on how these are computed are
                    below, adapted from the Smogon Stats FAQ:</p>

                    <ul>
                      <li>Usage: Usage Percentage is weighted by the skill
                      weighting selected.</li>
                      <li>Raw: Usage Percentage is unweighted by the skill
                      weighting.</li>
                      <li>Real: Only counts Pokemon that actually appear in
                      battle (Doubles not supported). Meaning that if a Pokemon
                      is not sent out, it is not counted.</li>
                    </ul>")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Where can I complain that if something went wrong?",
                    HTML("<p>Let me know about my incompetence by posting an
                    issue on the <a href = 'https://bit.ly/3bRvaTy'>project repo
                    </a> or dropping me an <a href = 'mailto: timlxq@gmail.com'>
                    email</a>. Vehemence is discouraged, but your Freedom of
                    Speech is respected.</p>")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Where can I access the raw data, and additional
                    resources?",
                    HTML("
                    <ul>
                    <li><a href = 'https://www.smogon.com/stats/'>Raw data</a>
                    </li>
                    <li><a href = 'https://bit.ly/39KZVrN'>Smogon Stats FAQ </a>
                    </li>
                    <li><a href = 'https://bit.ly/3aPamfe'>Latest Smogon Stats
                    Discussion Thread</a>
                    </li>
                    </ul>")
                  )
                ),
            fluidRow(
                box(width = 12,
                    title = "Where do I play some Pokemon?",
                    HTML("<a href = 'https://play.pokemonshowdown.com/'>
                    Glad you asked</a>")
                  )
                )
        )
    )
)

ui <- dashboardPage(header, sidebar, body)
# Define UI for application that draws a histogram
