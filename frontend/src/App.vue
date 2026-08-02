<template>
  <div class="chat-container">
    <!-- 移动端侧边栏切换按钮 -->
    <button class="mobile-sidebar-toggle" @click="toggleSidebar">
      {{ isSidebarOpen ? '×' : '☰' }}
    </button>
    <!-- 桌面端侧边栏切换按钮 -->
    <button class="desktop-sidebar-toggle" :class="{ collapsed: isSidebarCollapsed }" @click="toggleSidebarCollapse">
      {{ isSidebarCollapsed ? '→' : '←' }}
    </button>
    <!-- 侧边栏 -->
    <div class="sidebar" :class="{ open: isSidebarOpen, collapsed: isSidebarCollapsed }">
      <div class="sidebar-header">
        <h2>DBAgent</h2>
        <button @click="openNewChatModal" class="new-chat-btn" :disabled="isLoading">
          新建聊天
        </button>
      </div>
      <div class="sessions-list">
        <h3>历史会话</h3>
        <div class="sessions-container">
          <div v-for="(databaseSessions, database) in sessionsByDatabase" :key="database">
            <div class="database-header">MYSQL : {{ database }}</div>
            <div
              v-for="session in [...databaseSessions].reverse()"
              :key="session"
              class="session-item"
              :class="{ 'session-item-selected': selectedSession === session }"
            >
              <div @click="selectChat(session)">{{ session.split('_').slice(1).join('_') }}</div>
              <button
                class="delete-session-btn"
                @click.stop="confirmDeleteSession(session)"
                :disabled="isLoading"
                title="删除会话"
              >
                ×
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="sidebar-footer">
        <button @click="showAdminPasswordModal = true" class="graph-management-btn" :disabled="isLoading">
          图谱管理
        </button>
      </div>
    </div>

    <!-- 聊天主界面 -->
    <div class="chat-main" @click="closeSidebarOnMobile">
      <!-- 聊天头部 -->
      <div class="chat-header">
        <h3>{{ currentChatTitle.split('_').slice(1).join('_') }}</h3>
        <div class="view-toggle-buttons">
          <button
            class="view-toggle-btn"
            :class="{ 'active': activeView === 'chat' }"
            @click="toggleView('chat')"
            :disabled="isLoading"
          >
            聊天区
          </button>
          <button
            class="view-toggle-btn"
            :class="{ 'active': activeView === 'chart' }"
            @click="toggleView('chart')"
            :disabled="isLoading"
          >
            图表区
          </button>
        </div>
      </div>

      <!-- 聊天消息区域 -->
      <div v-if="activeView === 'chat'" class="chat-messages">
        <div v-for="(message, index) in messages" :key="index" class="message" :class="{ 'user-message': message.role === 'user', 'assistant-message': message.role === 'assistant' }">
          <!-- 删除消息按钮 -->
          <div v-if="message.role === 'user'" class="message-actions">
            <button @click="confirmDeleteMessage(index)" class="delete-message-btn" :disabled="isLoading">
              ×
            </button>
          </div>
          <div class="message-content">
            <!-- 可收起展开的思考内容 -->
            <div v-if="message.role === 'assistant' && message.reasoning" class="message-reasoning-container">
              <div class="message-reasoning-header" @click="message.reasoningExpanded = !message.reasoningExpanded">
                <strong>思考:</strong>
                <span class="reasoning-toggle">
                  {{ message.reasoningExpanded ? '▼' : '▶' }}
                </span>
              </div>
              <div v-if="message.reasoningExpanded" class="message-reasoning-content">
                {{ message.reasoning }}
              </div>
            </div>

            <!-- 显示查询结果 -->
            <div v-if="message.role === 'assistant' && message.results" class="message-results">
              <div class="message-results-header" @click="message.resultsExpanded = !message.resultsExpanded">
                <strong>查询结果:</strong>
                <span class="results-toggle">
                  {{ message.resultsExpanded ? '▼' : '▶' }}
                </span>
              </div>
              <div class="chat-table">
                <table>
                  <thead>
                    <tr>
                      <th v-for="(value, key) in message.results[0]" :key="key">{{ key }}</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(row, rowIndex) in (message.resultsExpanded ? message.results : message.results.slice(0, 5))" :key="rowIndex">
                      <td v-for="(value, key) in row" :key="key">{{ value }}</td>
                    </tr>
                    <tr v-if="!message.resultsExpanded && message.results.length > 5" class="results-more">
                      <td :colspan="Object.keys(message.results[0]).length" style="text-align: center; color: #666;">
                        ... 还有 {{ message.results.length - 5 }} 行结果
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- 显示最终回答 -->
            <div class="message-text" v-html="marked(message.content)"></div>
          </div>

          <!-- 重新生成按钮 -->
          <div v-if="message.role === 'assistant'" class="message-actions">
            <button @click="regenerateResponse(index)" class="regenerate-btn" :disabled="isLoading">
              重新生成
            </button>
            <!-- 前往图表区查看按钮 -->
            <button @click="goToChartView(index)" class="regenerate-btn" :disabled="isLoading">
              <span>前往图表区查看→</span>
            </button>
          </div>
        </div>
      </div>

      <!-- 输入区域 -->
      <div v-if="activeView === 'chat'" class="chat-input">
        <input
          v-model="inputMessage"
          @keyup.enter="sendMessage"
          placeholder="给 DBAgent 发送消息 ......"
          :disabled="isLoading || !selectedSession"
        />
        <button @click="sendMessage" :disabled="isLoading || !selectedSession" class="send-btn">
          {{ isLoading ? '生成中...' : '发送' }}
        </button>
      </div>

      <!-- 图表区域 -->
      <div v-if="activeView === 'chart'" class="chart-area">
        <div class="chart-header">
          <h3>{{ chartTitle }}</h3>
          <div class="chart-actions">
            <button
              @click="undoAction"
              class="undo-btn"
              :disabled="isLoading || history.length === 0"
              title="撤销操作"
            >
              ↩ 撤销
            </button>
            <button @click="loadChartData" class="load-data-btn" :disabled="isLoading">
              {{ isLoading ? '加载中...' : '加载原数据' }}
            </button>
          </div>
        </div>
        <div class="table-container" :class="{ 'table-container-shrinked': isGraphPanelOpen }">
          <el-table
            ref="tableRef"
            v-loading="isLoading"
            :data="paginatedChartData"
            style="width: 100%"
            @selection-change="handleSelectionChange"
            border
            :height="tableHeight"
          >
            <el-table-column
              type="selection"
              width="55"
            />
            <el-table-column
              v-for="column in tableColumns"
              :key="column.prop"
              :prop="column.prop"
              :label="column.label"
              :width="column.width"
              :sortable="column.sortable"
            >
              <template #header>
                <div class="column-header">
                  <div v-if="!editingColumnLabel || editingColumnLabel !== column.prop" @click="startEditColumnLabel(column.prop)">
                    <span>{{ column.label }}</span>
                  </div>
                  <input
                    v-else
                    ref="columnLabelInput"
                    v-model="editingLabelValue"
                    @blur="saveColumnLabel(column.prop)"
                    @keyup.enter="saveColumnLabel(column.prop)"
                    @keyup.esc="cancelEditColumnLabel"
                    class="column-label-input"
                    type="text"
                  />
                  <el-button
                    circle
                    @click.stop="deleteColumn(column.prop)"
                    title="删除列"
                    icon="Delete"
                    class="delete-column-btn"
                    :ripple="false"
                  >
                  </el-button>
                </div>
              </template>
              <template #default="scope">
                <div
                  v-if="!editingCell || editingCell.rowIndex !== scope.$index || editingCell.columnProp !== column.prop"
                  @dblclick="startEditCell(scope.$index, column.prop, scope.row)"
                  :title="scope.row[column.prop]"
                  class="cell-content"
                >{{ scope.row[column.prop] ?? '-' }}</div>
                <input
                  v-else
                  v-model="editingCellValue"
                  @blur="saveCell(scope.$index, column.prop, scope.row)"
                  @keyup.enter="saveCell(scope.$index, column.prop, scope.row)"
                  @keyup.esc="cancelEditCell"
                  class="cell-input"
                  type="text"
                />
              </template>
            </el-table-column>
          </el-table>
        </div>
        <div class="chart-footer">
          <div class="pagination-container" v-if="totalPages > 1">
            <button
              @click="prevPage"
              :disabled="currentPage === 1"
              class="pagination-btn"
            >
              ←
            </button>
            <template v-for="(page, index) in getPageNumbers()" :key="index">
              <span v-if="page === '...'" class="pagination-ellipsis">...</span>
              <button
                v-else
                @click="goToPage(page)"
                :class="{ 'pagination-btn-active': page === currentPage }"
                class="pagination-btn"
              >
                {{ page }}
              </button>
            </template>
            <button
              @click="nextPage"
              :disabled="currentPage === totalPages"
              class="pagination-btn"
            >
              →
            </button>
          </div>
          <div class="footer-actions">
            <span class="selected-info">
              已选择 {{ selectedRows.length }} 行 | 共 {{ chartData.length }} 条数据
            </span>
            <button
              @click="batchDelete"
              class="batch-delete-btn"
              :disabled="selectedRows.length === 0 || isLoading"
            >
              批量删除
            </button>
          </div>
        </div>

        <!-- 图表配置面板 -->
        <div class="chart-config-panel">
          <div class="config-group">
            <label class="config-label">图表类型：</label>
            <select v-model="chartType" class="config-select">
              <option value="line">曲线图</option>
              <option value="bar">柱状图</option>
              <option value="scatter">散点图</option>
              <option value="area">面积图</option>
              <option value="pie">饼图</option>
              <option value="histogram">直方图</option>
              <option value="box">箱线图</option>
            </select>
          </div>
          <div class="config-group" :class="{ 'config-group-hidden': chartType === 'pie' || chartType === 'box' || chartType === 'histogram' }">
            <label class="config-label">X轴：</label>
            <select v-model="xAxisColumn" class="config-select">
              <option value="">请选择</option>
              <option v-for="col in tableColumns" :key="col.prop" :value="col.prop">{{ col.label }}</option>
            </select>
          </div>
          <div class="config-group">
            <label class="config-label">{{ chartType === 'pie' ? '类别列：' : '数据列：' }}</label>
            <div class="multi-select-wrapper">
              <input
                type="text"
                :value="selectedYColumns.length > 0 ? selectedYColumns.map(c => tableColumns.find(tc => tc.prop === c)?.label || c).join(', ') : '点击选择'"
                class="multi-select-input"
                readonly
                @click="showColumnSelector = true"
              />
            </div>
          </div>
          <button @click="createChart" class="create-chart-btn" :disabled="isLoading">
            添加图表
          </button>
        </div>

        <!-- 列选择器弹窗 -->
        <div v-if="showColumnSelector" class="modal-overlay" @click="showColumnSelector = false">
          <div class="column-selector-modal" @click.stop>
            <div class="modal-header">
              <h3>{{ chartType === 'pie' ? '选择类别列' : '选择数据列（可多选）' }}</h3>
              <button @click="showColumnSelector = false" class="modal-close">×</button>
            </div>
            <div class="modal-body">
              <div class="transfer-wrapper">
                <el-transfer
                  v-model="selectedYColumns"
                  :data="transferColumns"
                  :titles="['可选列', '已选列']"
                  :button-texts="['移除', '添加']"
                  :filterable="true"
                  filter-placeholder="搜索列名"
                  :max-height="300"
                />
              </div>
            </div>
            <div class="modal-footer">
              <button @click="showColumnSelector = false" class="cancel-btn">取消</button>
              <button @click="confirmColumnSelection" class="confirm-btn">确认</button>
            </div>
          </div>
        </div>

        <!-- 图表展示面板 -->
        <div class="graph-panel-toggle" @click="toggleGraphPanel">
          <span class="toggle-icon">{{ isGraphPanelOpen ? '▼' : '▲' }}</span>
          <span class="toggle-text">{{ isGraphPanelOpen ? '收起图表' : '展开图表' }}</span>
        </div>
        <div class="graph-panel" :class="{ 'graph-panel-expanded': isGraphPanelOpen }">
          <div class="charts-scroll-container">
            <div v-if="chartList.length === 0" class="graph-placeholder">
              <div class="graph-title">图表展示区域</div>
              <div class="graph-content">
                <p>请选择图表类型，配置X轴或Y轴列，然后点击"添加图表"按钮</p>
              </div>
            </div>
            <div v-else class="charts-container">
              <div v-for="chart in chartList" :key="chart.id" class="chart-item">
                <div class="chart-header-wrapper">
                  <span class="chart-title">{{ chart.title }}</span>
                  <button @click="deleteChart(chart.id)" class="delete-chart-btn" title="删除图表">
                    ×
                  </button>
                </div>
                <div :id="'chart-' + chart.id" class="chart-content"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

    <!-- 新建聊天模态框 -->
    <div v-if="showNewChatModal" class="modal-overlay" @click="showNewChatModal = false">
      <div class="modal-content" @click.stop>
        <h3>新建聊天</h3>
        <div class="modal-body">
          <label>选择数据库:</label>
          <select v-model="selectedDatabase" class="database-select">
            <option v-for="db in databases" :key="db" :value="db">{{ db }}</option>
          </select>
        </div>
        <div class="modal-footer">
          <button @click="showNewChatModal = false" class="cancel-btn">取消</button>
          <button @click="createNewChat" class="confirm-btn">确认</button>
        </div>
      </div>
    </div>

    <!-- 删除确认模态框 -->
    <div v-if="showDeleteConfirmModal" class="modal-overlay" @click="showDeleteConfirmModal = false">
      <div class="modal-content" @click.stop>
        <h3>删除会话确认</h3>
        <div class="modal-body">
          <p>确定要删除会话 "{{ sessionToDelete }}" 吗？此操作不可恢复。</p>
        </div>
        <div class="modal-footer">
          <button @click="showDeleteConfirmModal = false" class="cancel-btn">取消</button>
          <button @click="deleteSession" class="confirm-btn delete-confirm-btn">
            确定删除
          </button>
        </div>
      </div>
    </div>

    <!-- 删除消息确认模态框 -->
    <div v-if="showDeleteMessageModal" class="modal-overlay" @click="showDeleteMessageModal = false">
      <div class="modal-content" @click.stop>
        <h3>删除消息确认</h3>
        <div class="modal-body">
          <p>确定要删除这条消息及其对应回答吗？此操作不可恢复。</p>
        </div>
        <div class="modal-footer">
          <button @click="showDeleteMessageModal = false" class="cancel-btn">取消</button>
          <button @click="deleteMessage" class="confirm-btn delete-confirm-btn">
            确定删除
          </button>
        </div>
      </div>
    </div>

    <!-- 管理员密码验证模态框 -->
    <div v-if="showAdminPasswordModal" class="modal-overlay" @click="showAdminPasswordModal = false">
      <div class="modal-content" @click.stop>
        <h3>请输入管理员密码</h3>
        <div class="modal-body">
          <label>密码:</label>
          <input
            v-model="adminPassword"
            type="password"
            placeholder="请输入密码"
            class="password-input"
            @keyup.enter="verifyAdminPassword"
          />
          <div v-if="passwordError" class="password-error">
            {{ passwordError }}
          </div>
        </div>
        <div class="modal-footer">
          <button @click="showAdminPasswordModal = false" class="cancel-btn">取消</button>
          <button @click="verifyAdminPassword" class="confirm-btn">确认</button>
        </div>
      </div>
    </div>

    <!-- 图谱管理模态框 -->
    <div v-if="showGraphManagementModal" class="modal-overlay" @click="showGraphManagementModal = false">
      <div class="modal-content" @click.stop>
        <h3>图谱管理</h3>
        <div class="modal-body">
          <div v-if="isLoadingGraphs" class="loading-indicator">
            加载中...
          </div>
          <div v-else-if="databasesList.length === 0" class="empty-graphs">
            <p>没有找到数据库</p>
          </div>
          <div v-else class="graphs-list">
            <div v-for="(database, index) in databasesList" :key="index" class="graph-item">
              <div class="graph-info">
                <span class="graph-name">{{ database }}</span>
                <span v-if="getGraphMapping(database)" class="graph-mapping">{{ getGraphMapping(database) }}</span>
              </div>
              <button
                v-if="getGraphMapping(database)"
                @click="confirmDeleteGraph({ name: database, mapping: getGraphMapping(database) })"
                class="delete-graph-btn"
                :disabled="isLoading"
              >
                删除
              </button>
              <button
                v-else
                @click="createGraph(database)"
                class="create-graph-btn"
                :disabled="creatingDatabases.has(database)"
              >
                {{ creatingDatabases.has(database) ? '创建中...' : '创建' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
import { ref, onMounted, onBeforeUnmount, watch, nextTick, computed } from 'vue'
import axios from 'axios'
import { marked } from 'marked'
import { ElMessage } from 'element-plus'
import * as Plotly from 'plotly.js-dist'

// 设置axios基础URL为相对路径，适配开发和生产环境
axios.defaults.baseURL = 'http://localhost:8000'

// 生成或获取用户唯一标识
const getUserId = () => {
  let userId = localStorage.getItem('dbagent_user_id')
  if (!userId) {
    userId = 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9)
    localStorage.setItem('dbagent_user_id', userId)
  }
  return userId
}

const userId = getUserId()

export default {
  name: 'App',
  setup() {
    // 状态
    const messages = ref([])
    const inputMessage = ref('')
    const isLoading = ref(false)
    const sessions = ref([])
    const databases = ref([])
    const showNewChatModal = ref(false)
    const showDeleteConfirmModal = ref(false)
    const showDeleteMessageModal = ref(false)
    const selectedDatabase = ref('')
    const currentChatTitle = ref('新聊天')
    const selectedSession = ref('')
    const sessionToDelete = ref('')
    const messageToDelete = ref(-1)
    const isSidebarOpen = ref(false)
    const isSidebarCollapsed = ref(false)
    const activeView = ref('chat') // 'chat' or 'chart'
    // 会话消息缓存，用于存储每个会话的历史消息，从localStorage加载
    const sessionMessagesCache = ref(JSON.parse(localStorage.getItem('sessionMessagesCache')) || {})
    // 存储会话对应的数据库列表，与sessions列表一一对应
    const sessionDatabases = ref([])
    // 图谱管理相关状态
    const showGraphManagementModal = ref(false)
    const showAdminPasswordModal = ref(false)
    const adminPassword = ref('')
    const passwordError = ref('')
    const graphsList = ref([])
    const databasesList = ref([])
    const isLoadingGraphs = ref(false)
    const graphToDelete = ref(null)
    const creatingDatabases = ref(new Set())

    // 图表区相关状态
    const chartData = ref([])
    const tableColumns = ref([])
    const selectedRows = ref([])
    const currentQuestionIndex = ref(null)
    const chartTitle = ref('数据表格')
    const tableRef = ref(null)
    // 图表展示面板状态
    const isGraphPanelOpen = ref(false)
    // 分页相关状态
    const currentPage = ref(1)
    const pageSize = ref(100)
    const totalPages = computed(() => {
      return Math.ceil(chartData.value.length / pageSize.value)
    })

    // 分页后的数据
    const paginatedChartData = computed(() => {
      console.log('计算分页数据，chartData:', {
        isArray: Array.isArray(chartData.value),
        length: chartData.value?.length,
        currentPage: currentPage.value,
        pageSize: pageSize.value
      })

      if (!Array.isArray(chartData.value) || chartData.value.length === 0) {
        console.log('返回空数组')
        return []
      }

      const start = (currentPage.value - 1) * pageSize.value
      const end = start + pageSize.value
      const result = chartData.value.slice(start, end)
      console.log('分页数据计算:', {
        currentPage: currentPage.value,
        pageSize: pageSize.value,
        total: chartData.value.length,
        start,
        end,
        resultLength: result.length,
        sampleResult: result.slice(0, 2)
      })
      return result
    })

    // 表格高度计算（虚拟滚动需要固定高度）
    const tableHeight = computed(() => {
      const headerHeight = 60 // chart-header 高度
      const footerHeight = 80 // chart-footer 高度（包含分页）
      const configPanelHeight = 60 // chart-config-panel 高度
      const toggleHeight = 30 // graph-panel-toggle 高度
      const windowHeight = window.innerHeight
      const sidebarWidth = isSidebarCollapsed.value ? 48 : 250

      let availableHeight = windowHeight - headerHeight - footerHeight - configPanelHeight - toggleHeight - 120 // 额外边距

      // 如果图表面板展开，减少表格高度
      if (isGraphPanelOpen.value) {
        availableHeight = Math.max(200, availableHeight - 250)
      }

      return availableHeight + 'px'
    })

    // 图表配置相关状态
    const chartType = ref('line') // 图表类型: line, bar, scatter
    const xAxisColumn = ref('') // X轴列
    const yAxisColumn = ref('') // Y轴列（兼容旧代码）
    const selectedYColumns = ref([]) // 选中的Y轴数据列（支持多选）
    const showColumnSelector = ref(false) // 是否显示列选择器弹窗
    const chartList = ref([]) // 存储已创建的图表列表
    let chartIdCounter = 0 // 图表ID计数器

    // 穿梭框数据
    const transferColumns = ref([])
    // 监听tableColumns变化，更新穿梭框数据
    watch(tableColumns, (newColumns) => {
      transferColumns.value = newColumns.map(col => ({
        key: col.prop,
        label: col.label
      }))
    }, { deep: true, immediate: true })

    // 确认列选择
    const confirmColumnSelection = () => {
      showColumnSelector.value = false
      // 更新yAxisColumn用于兼容旧代码（取第一个选中的列）
      if (selectedYColumns.value.length > 0) {
        yAxisColumn.value = selectedYColumns.value[0]
      }
    }

    // 编辑相关状态
    const editingCell = ref(null) // { rowIndex, columnProp }
    const editingCellValue = ref('')
    const editingColumnLabel = ref(null) // prop of column being edited
    const editingLabelValue = ref('')
    // 撤销历史记录
    const history = ref([])

    // 使用WeakSet优化选中行的查找
    const selectedRowsSet = computed(() => {
      const set = new WeakSet()
      selectedRows.value.forEach(row => set.add(row))
      return set
    })

    // 加载会话和数据库列表
    onMounted(() => {
      loadSessions()
      loadGraphs()

      // 监听页面关闭和刷新事件
      window.addEventListener('beforeunload', handleBeforeUnload)
    })

    // 页面卸载前的处理
    onBeforeUnmount(() => {
      // 移除事件监听器
      window.removeEventListener('beforeunload', handleBeforeUnload)
      // 调用退出API
      logout()
    })

    // 页面关闭前的处理
    const handleBeforeUnload = () => {
      logout()
    }

    // 退出登录
    const logout = async () => {
      try {
        await axios.post('/chat/logout', {
          user_id: userId
        })
      } catch (error) {
        console.error('退出失败:', error)
      }
    }

    // 监听会话消息缓存的变化，自动保存到localStorage
    watch(sessionMessagesCache, (newValue) => {
      localStorage.setItem('sessionMessagesCache', JSON.stringify(newValue))
    }, { deep: true })

    // 监听图谱管理模态框的显示状态，自动加载图谱
    watch(showGraphManagementModal, (newValue) => {
      if (newValue) {
        loadGraphs()
      }
    })

    // 按数据库分组的会话
    const sessionsByDatabase = ref({})

    // 加载会话列表
    const loadSessions = async () => {
      try {
        const response = await axios.get('/chat/sessions', {
          params: { user_id: userId }
        })
        sessions.value = response.data.sessions
        sessionDatabases.value = response.data.databases || []
        // 按数据库分组会话
        groupSessionsByDatabase()
      } catch (error) {
        if (error.response && error.response.status === 503) {
          ElMessage({
            message: error.response.data.detail || '服务器用户数量已达上限，请稍后再试',
            type: 'error',
            duration: 5000,
            showClose: true
          })
        } else {
          console.error('加载会话列表失败:', error)
        }
      }
    }

    // 按数据库分组会话
    const groupSessionsByDatabase = () => {
      const grouped = {}
      sessions.value.forEach((session, index) => {
        const database = sessionDatabases.value[index] || '其他'
        if (!grouped[database]) {
          grouped[database] = []
        }
        grouped[database].push(session)
      })
      sessionsByDatabase.value = grouped
    }

    // 验证管理员密码
    const verifyAdminPassword = async () => {
      if (!adminPassword.value.trim()) {
        passwordError.value = '请输入密码'
        return
      }

      try {
        const response = await axios.post('/graph/verify_admin', {
          password: adminPassword.value
        })

        if (response.data.success) {
          passwordError.value = ''
          showAdminPasswordModal.value = false
          adminPassword.value = ''
          showGraphManagementModal.value = true
        } else {
          passwordError.value = '密码错误，请重试'
        }
      } catch (error) {
        console.error('验证密码失败:', error)
        passwordError.value = '验证失败，请重试'
      }
    }

    // 加载图谱列表和数据库列表
    const loadGraphs = async () => {
      try {
        isLoadingGraphs.value = true
        // 同时加载图谱映射和数据库列表
        const [graphsResponse, databasesResponse] = await Promise.all([
          axios.get('/graph/get_graphs'),
          axios.get('/chat/databases')
        ])
        graphsList.value = graphsResponse.data.graphs || []
        databasesList.value = (databasesResponse.data.databases || []).sort((a, b) => a.localeCompare(b))
      } catch (error) {
        console.error('加载图谱列表失败:', error)
        graphsList.value = []
        databasesList.value = []
      } finally {
        isLoadingGraphs.value = false
      }
    }

    // 确认删除图谱
    const confirmDeleteGraph = (graph) => {
      graphToDelete.value = graph
      if (confirm(`确定要删除图谱 "${graph.name}"吗？此操作不可恢复。`)) {
        deleteGraph()
      }
    }

    // 删除图谱
    const deleteGraph = async () => {
      if (!graphToDelete.value) return

      try {
        isLoading.value = true
        await axios.delete(`/graph/delete_graph`, {
          data: {
            name: graphToDelete.value.name,
            mapping: graphToDelete.value.mapping
          }
        })
        // 重新加载图谱列表
        await loadGraphs()
        ElMessage({
          message: '图谱删除成功！',
          type: 'success',
          duration: 3000
        })
      } catch (error) {
        console.error('删除图谱失败:', error)
        ElMessage({
          message: '删除图谱失败，请重试。',
          type: 'error',
          duration: 3000
        })
      } finally {
        isLoading.value = false
        graphToDelete.value = null
      }
    }

    // 获取数据库对应的图谱映射
    const getGraphMapping = (databaseName) => {
      const graph = graphsList.value.find(g => g.name === databaseName)
      return graph ? graph.mapping : null
    }

    // 创建图谱
    const createGraph = async (databaseName) => {
      try {
        creatingDatabases.value.add(databaseName)
        await axios.delete('/graph/create_graph', {
          data: {
            database_name: databaseName
          }
        })
        await loadGraphs()
        ElMessage({
          message: '图谱创建成功！',
          type: 'success',
          duration: 3000
        })
      } catch (error) {
        console.error('创建图谱失败:', error)
        ElMessage({
          message: '创建图谱失败，请重试。',
          type: 'error',
          duration: 3000
        })
      } finally {
        creatingDatabases.value.delete(databaseName)
      }
    }

    // 加载数据库列表
    const loadDatabases = async () => {
      try {
        const response = await axios.get('/chat/databases')
        databases.value = response.data.databases
        if (databases.value.length > 0) {
          selectedDatabase.value = databases.value[0]
        }
      } catch (error) {
        console.error('加载数据库列表失败:', error)
      }
    }

    // 打开新建聊天模态框，只显示有图谱的数据库
    const openNewChatModal = async () => {
      try {
        isLoading.value = true
        const response = await axios.get('/graph/get_graphs')
        const graphs = response.data.graphs || []
        graphsList.value = graphs
        const databasesWithGraph = graphs.map(g => g.name)
        databases.value = databasesWithGraph.sort((a, b) => a.localeCompare(b))
        if (databases.value.length > 0) {
          selectedDatabase.value = databases.value[0]
        } else {
          selectedDatabase.value = ''
          ElMessage({
            message: '暂无可用的图谱，请先创建图谱',
            type: 'warning',
            duration: 3000
          })
        }
        showNewChatModal.value = true
      } catch (error) {
        console.error('加载图谱列表失败:', error)
        databases.value = []
        selectedDatabase.value = ''
        showNewChatModal.value = true
      } finally {
        isLoading.value = false
      }
    }

    // 创建新聊天
    const createNewChat = async () => {
      if (!selectedDatabase.value) return

      try {
        isLoading.value = true
        const graphName = getGraphMapping(selectedDatabase.value)
        await axios.post('/chat/select_chat', {
          database_name: selectedDatabase.value,
          graph_name: graphName,
          user_id: userId
        })
        messages.value = []
        showNewChatModal.value = false
        // 自动切换回聊天视图，确保新会话能正常接收用户问题
        activeView.value = 'chat'
        // 重新加载会话列表，确保新创建的会话能显示
        await loadSessions()
        // 查找并选中新创建的会话（最新的会话）
        const filteredSessions = sessions.value.filter(session =>
          session.includes(selectedDatabase.value)
        )
        // 按时间戳排序，找到最新的会话
        filteredSessions.sort((a, b) => {
          const timestampA = parseInt(a.split('_')[0])
          const timestampB = parseInt(b.split('_')[0])
          return timestampB - timestampA
        })
        const newSession = filteredSessions[0]
        // 设置当前选中的会话
        if (newSession) {
          selectedSession.value = newSession
          currentChatTitle.value = newSession
        } else {
          currentChatTitle.value = `新聊天 - ${selectedDatabase.value}`
        }
      } catch (error) {
        console.error('创建新聊天失败:', error)
        if (error.response && error.response.status === 500 &&
            error.response.data.detail &&
            error.response.data.detail.includes('Failed to load database')) {
          ElMessage({
            message: '找不到图谱，请联系管理员添加图谱',
            type: 'error',
            duration: 3000
          })
        }
      } finally {
        isLoading.value = false
        // 更新当前会话的消息缓存
        if (selectedSession.value) {
          sessionMessagesCache.value[selectedSession.value] = [...messages.value]
        }
        // 重新分组会话
        groupSessionsByDatabase()
      }
    }

    // 选择已有聊天
    const selectChat = async (session) => {
      // 等待回答时禁止选择其他会话
      if (isLoading.value) return

      try {
        isLoading.value = true
        // 先保存当前会话的消息到缓存
        if (selectedSession.value) {
          sessionMessagesCache.value[selectedSession.value] = [...messages.value]
        }

        // 找到会话对应的数据库名称
        const sessionIndex = sessions.value.indexOf(session)
        const databaseName = sessionIndex !== -1 && sessionDatabases.value[sessionIndex] ? sessionDatabases.value[sessionIndex] : ''
        const graphName = getGraphMapping(databaseName)

        await axios.post('/chat/select_chat', {
          chat_name: session,
          database_name: databaseName,
          graph_name: graphName,
          user_id: userId
        })
        await loadSessions()
        // 从缓存中加载历史消息，如果缓存中没有，就初始化一个空数组
        if (!sessionMessagesCache.value[session]) {
          sessionMessagesCache.value[session] = []
        }
        messages.value = [...sessionMessagesCache.value[session]]
        currentQuestionIndex.value = null
        currentChatTitle.value = session
        // 设置当前选中的会话
        selectedSession.value = session
        // 强制切换回聊天区
        activeView.value = 'chat'
      } catch (error) {
        console.error('选择会话失败:', error)
        if (error.response && error.response.status === 500 &&
            error.response.data.detail &&
            error.response.data.detail.includes('Failed to load database')) {
          ElMessage({
            message: '找不到图谱，请联系管理员添加图谱',
            type: 'error',
            duration: 3000
          })
        }
      } finally {
        isLoading.value = false
      }
    }

    // 发送消息
    const sendMessage = async () => {
      if (!inputMessage.value.trim() || isLoading.value || !selectedSession.value) return

      const message = inputMessage.value.trim()
      messages.value.push({ role: 'user', content: message })
      inputMessage.value = ''
      isLoading.value = true

      try {
        // 这里使用正常的请求，因为后端目前不支持SSE流式传输
        const response = await axios.post('/chat/ask_question', {
          question: message,
          user_id: userId
        })

        // 根据用户需求，只显示第一个思考内容和最终结果
        messages.value.push({
          role: 'assistant',
          content: response.data.output,
          reasoning: response.data.reasoning,
          results: response.data.results,
          reasoningExpanded: false, // 默认收起思考内容
          resultsExpanded: false // 默认收起查询结果
        })

        // 如果是第一个消息，重新加载会话列表，确保新会话显示在历史记录中
        if (messages.value.length === 2) { // 1个用户消息 + 1个助手回复
          await loadSessions()
          // 找到并选中更新后的会话
          // 尝试找到包含原始会话ID部分的会话
          if (selectedSession.value) {
            const originalSessionParts = selectedSession.value.split('_')
            if (originalSessionParts.length > 1) {
              const timestampPart = originalSessionParts[0]
              const updatedSession = sessions.value.find(session => session.includes(timestampPart))
              // 如果找到了更新后的会话，选中它
              if (updatedSession) {
                selectedSession.value = updatedSession
                currentChatTitle.value = updatedSession
              }
            }
          }
        }

        // 更新当前会话的消息缓存
        if (selectedSession.value) {
          sessionMessagesCache.value[selectedSession.value] = [...messages.value]
        }
      } catch (error) {
        console.error('发送消息失败:', error)
        messages.value.push({
          role: 'assistant',
          content: '抱歉，处理您的请求时出现错误。'
        })
        // 即使发送失败，也更新当前会话的消息缓存
        if (selectedSession.value) {
          sessionMessagesCache.value[selectedSession.value] = [...messages.value]
        }
      } finally {
        isLoading.value = false
      }
    }

    // 重新生成回答
    const regenerateResponse = async (messageIndex) => {
      // 找到对应的用户消息
      if (messageIndex === 0) return

      const userMessage = messages.value[messageIndex - 1]
      if (userMessage.role !== 'user') return

      // 计算问题的索引（从0开始计数）
      let questionIndex = 0
      for (let i = 0; i < messageIndex - 1; i++) {
        if (messages.value[i].role === 'user') {
          questionIndex++
        }
      }

      // 保留原来的位置
      const originalIndex = messageIndex
      // 删除当前回答
      messages.value.splice(messageIndex, 1)
      isLoading.value = true

      try {
        const response = await axios.post('/chat/regenerate', {
          question_index: questionIndex,
          user_id: userId
        })
        currentQuestionIndex.value = null
        // 在原来的位置插入新答案
        messages.value.splice(originalIndex, 0, {
          role: 'assistant',
          content: response.data.output,
          reasoning: response.data.reasoning,
          results: response.data.results,
          reasoningExpanded: false,
          resultsExpanded: false
        })


      } catch (error) {
        console.error('重新生成失败:', error)
        // 在原来的位置插入错误消息
        messages.value.splice(originalIndex, 0, {
          role: 'assistant',
          content: '抱歉，重新生成时出现错误。'
        })
      } finally {
        isLoading.value = false
        // 更新当前会话的消息缓存
        if (selectedSession.value) {
          sessionMessagesCache.value[selectedSession.value] = [...messages.value]
        }
      }
    }

    // 确认删除会话
    const confirmDeleteSession = (session) => {
      sessionToDelete.value = session
      showDeleteConfirmModal.value = true
    }

    // 删除会话
    const deleteSession = async () => {
      if (isLoading.value || !sessionToDelete.value) return

      try {
        isLoading.value = true
        await axios.post('/chat/delete_session', {
          session_name: sessionToDelete.value,
          user_id: userId
        })
        await loadSessions()
        // 从缓存中删除会话消息
        delete sessionMessagesCache.value[sessionToDelete.value]
        // 如果删除的是当前选中的会话，清空当前聊天
        if (selectedSession.value === sessionToDelete.value) {
          selectedSession.value = ''
          currentChatTitle.value = '新聊天'
          messages.value = []
        }
      } catch (error) {
        console.error('删除会话失败:', error)
      } finally {
        isLoading.value = false
        showDeleteConfirmModal.value = false
        sessionToDelete.value = ''
        // 重新分组会话
        groupSessionsByDatabase()
      }
    }

    // 确认删除消息
    const confirmDeleteMessage = (index) => {
      messageToDelete.value = index
      showDeleteMessageModal.value = true
    }

    // 删除消息
    const deleteMessage = async () => {
      if (isLoading.value || messageToDelete.value < 0) return

      try {
        isLoading.value = true
        const userMessage = messages.value[messageToDelete.value]
        if (userMessage.role !== 'user') return

        // 计算问题的索引（从0开始计数）
        let questionIndex = 0
        for (let i = 0; i < messageToDelete.value; i++) {
          if (messages.value[i].role === 'user') {
            questionIndex++
          }
        }

        // 发送删除消息请求到后端
        await axios.post('/chat/delete_message', {
          question_index: questionIndex,
          user_id: userId
        })
        currentQuestionIndex.value = null
        // 删除用户消息及其对应的助手回答
        let deleteCount = 1
        if (messageToDelete.value + 1 < messages.value.length && messages.value[messageToDelete.value + 1].role === 'assistant') {
          deleteCount = 2
        }
        messages.value.splice(messageToDelete.value, deleteCount)

        // 更新当前会话的消息缓存
        if (selectedSession.value) {
          sessionMessagesCache.value[selectedSession.value] = [...messages.value]
          // 确保更新localStorage
          localStorage.setItem('sessionMessagesCache', JSON.stringify(sessionMessagesCache.value))
        }
      } catch (error) {
        console.error('删除消息失败:', error)
      } finally {
        isLoading.value = false
        showDeleteMessageModal.value = false
        messageToDelete.value = -1
      }
    }

    // 切换侧边栏显示状态
    const toggleSidebar = () => {
      isSidebarOpen.value = !isSidebarOpen.value
    }

    // 切换侧边栏收起状态
    const toggleSidebarCollapse = () => {
      isSidebarCollapsed.value = !isSidebarCollapsed.value
    }

    // 在移动端点击主内容区域关闭侧边栏
    const closeSidebarOnMobile = () => {
      if (window.innerWidth <= 768) {
        isSidebarOpen.value = false
      }
    }

    // 切换视图（聊天区/图表区）
    const toggleView = async (view) => {
      activeView.value = view
      // 如果切换到图表视图，且有已创建的图表，需要重新渲染
      if (view === 'chart' && chartList.value.length > 0) {
        await nextTick()
        chartList.value.forEach(chart => {
          renderChart(chart)
        })
      }
    }

    // 前往图表区查看
    const goToChartView = async (messageIndex) => {
      activeView.value = 'chart'
      // 计算问题的索引（从0开始计数）
      let questionIndex = 0
      for (let i = 0; i < messageIndex - 1; i++) {
        if (messages.value[i].role === 'user') {
          questionIndex++
        }
      }
      currentQuestionIndex.value = questionIndex
      // 获取对应的问题内容作为图表标题
      if (messageIndex > 0 && messages.value[messageIndex - 1].role === 'user') {
        const questionContent = messages.value[messageIndex - 1].content
        // 限制标题长度，避免过长
        chartTitle.value = questionContent.length > 50 ? questionContent.substring(0, 50) + '...' : questionContent
      } else {
        chartTitle.value = '数据表格'
      }
      // 加载图表数据
      await loadChartData()
      // 数据加载完成后重新渲染所有图表
      if (chartList.value.length > 0) {
        await nextTick()
        chartList.value.forEach(chart => {
          renderChart(chart)
        })
      }
    }

    // 加载图表数据
    const loadChartData = async () => {
      try {
        isLoading.value = true

        const response = await axios.post('/chat/get_data', {
          question_index: currentQuestionIndex.value,
          user_id: userId
        })

        // 打印 SQL 到控制台
        if (response.data.sql) {
          console.log('transformed SQL:', response.data.sql)
        }

        let data = []
        if (response.data && typeof response.data === 'object') {
          if (Array.isArray(response.data.results)) {
            data = response.data.results
          } else if (Array.isArray(response.data.data)) {
            data = response.data.data
          } else if (Array.isArray(response.data)) {
            data = response.data
          } else {
            try {
              for (const key in response.data) {
                if (Array.isArray(response.data[key])) {
                  data = response.data[key]
                  break
                }
              }
            } catch (e) {
              console.error('转换数据失败:', e)
            }
          }
        }

        chartData.value = data
        console.log('数据加载完成:', {
          dataLength: data.length,
          firstItem: data[0],
          chartDataLength: chartData.value.length,
          isArray: Array.isArray(chartData.value),
          sampleData: data.slice(0, 3)
        })
        // 重置到第一页
        currentPage.value = 1
        // 等待响应式更新
        await nextTick()
        console.log('重置页码后:', {
          currentPage: currentPage.value,
          paginatedDataLength: paginatedChartData.value.length,
          paginatedData: paginatedChartData.value.slice(0, 3)
        })

        if (Array.isArray(chartData.value) && chartData.value.length > 0) {
          const firstRow = chartData.value[0]

          if (firstRow && typeof firstRow === 'object') {
            tableColumns.value = Object.keys(firstRow).map(key => {
              return {
                prop: key,
                label: key,
                width: 180,
                sortable: true
              }
            })
          } else {
            tableColumns.value = []
          }
        } else {
          tableColumns.value = []
        }

        // 显示加载成功信息
        ElMessage({
          message: `加载成功，共 ${chartData.value.length} 条数据`,
          type: 'success',
          duration: 3000
        })

      } catch (error) {
        console.error('加载图表数据失败:', error)
        console.error('错误详情:', error.response ? error.response.data : error.message)
        ElMessage({
          message: '加载数据失败，请先指定一个查询或检查控制台错误信息。',
          type: 'error',
          duration: 3000
        })
        // 清空数据，避免显示旧数据
        chartData.value = []
        tableColumns.value = []
        currentPage.value = 1
      } finally {
        isLoading.value = false
      }
    }

    // 分页方法
    const goToPage = (page) => {
      if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page
        console.log('跳转到页面:', page, '当前分页数据长度:', paginatedChartData.value.length)
      }
    }

    const prevPage = () => {
      if (currentPage.value > 1) {
        currentPage.value--
      }
    }

    const nextPage = () => {
      if (currentPage.value < totalPages.value) {
        currentPage.value++
      }
    }

    // 生成分页页码数组
    const getPageNumbers = () => {
      const total = totalPages.value
      const current = currentPage.value
      const pageNumbers = []

      if (total <= 7) {
        // 页码少于等于7个，全部显示
        for (let i = 1; i <= total; i++) {
          pageNumbers.push(i)
        }
      } else {
        // 页码超过7个，显示省略号
        if (current <= 3) {
          // 当前页在前面
          pageNumbers.push(1, 2, 3, 4, '...', total)
        } else if (current >= total - 2) {
          // 当前页在后面
          pageNumbers.push(1, '...', total - 3, total - 2, total - 1, total)
        } else {
          // 当前页在中间
          pageNumbers.push(1, '...', current - 1, current, current + 1, '...', total)
        }
      }

      return pageNumbers
    }

    // 处理行选择
    const handleSelectionChange = (val) => {
      selectedRows.value = val
    }

    // 删除列
    const deleteColumn = (prop) => {
      if (prop) {
        // 保存历史记录
        saveHistory('deleteColumn', {
          columns: JSON.parse(JSON.stringify(tableColumns.value)),
          data: JSON.parse(JSON.stringify(chartData.value))
        })
        // 删除列配置
        tableColumns.value = tableColumns.value.filter(column => column.prop !== prop)
        // 从数据中删除对应列
        chartData.value = chartData.value.map(row => {
          const newRow = { ...row }
          delete newRow[prop]
          return newRow
        })
        ElMessage({
          message: '列删除成功',
          type: 'success',
          duration: 2000
        })
      }
    }

    // 保存历史记录用于撤销（优化版本）
    const saveHistory = (actionType, data) => {
      // 限制历史记录数量，避免内存过大
      if (history.value.length >= 30) {
        history.value.shift()
      }

      // 对于大数据量操作，只保存差异而不是完整数据
      let savedData
      if (actionType === 'batchDelete' && data && data.length > 1000) {
        // 大数据量时只保存删除的行数和索引范围
        savedData = {
          rowCount: data.length,
          type: 'largeData'
        }
      } else {
        savedData = JSON.parse(JSON.stringify(data))
      }

      history.value.push({
        actionType,
        data: savedData
      })
    }

    // 撤销操作（优化版本）
    const undoAction = () => {
      if (history.value.length === 0) return

      const lastAction = history.value.pop()
      switch (lastAction.actionType) {
        case 'deleteColumn':
          // 恢复删除的列
          tableColumns.value = lastAction.data.columns
          chartData.value = lastAction.data.data
          break
        case 'batchDelete':
          // 恢复删除的行（处理大数据量情况）
          if (lastAction.data.type === 'largeData') {
            // 大数据量时无法恢复，提示用户
            ElMessage({
              message: `数据量较大，无法撤销此操作`,
              type: 'warning',
              duration: 3000
            })
            return
          }
          chartData.value = lastAction.data
          break
        case 'editCell':
          // 恢复单元格原值（使用全局索引）
          const rowIndex = lastAction.data.rowIndex
          if (rowIndex >= 0 && rowIndex < chartData.value.length) {
            chartData.value[rowIndex][lastAction.data.columnProp] = lastAction.data.oldValue
          }
          break
        case 'editColumnLabel':
          // 恢复列名原值
          const column = tableColumns.value.find(col => col.prop === lastAction.data.prop)
          if (column) {
            column.label = lastAction.data.oldLabel
          }
          break
        default:
          break
      }
      ElMessage({
        message: '已撤销',
        type: 'success',
        duration: 2000
      })
    }

    // 开始编辑单元格
    const startEditCell = (rowIndex, columnProp, row) => {
      editingCell.value = { rowIndex, columnProp }
      const cellValue = row[columnProp]
      editingCellValue.value = cellValue === null ? '' : String(cellValue)
    }

    // 保存单元格编辑
    const saveCell = (rowIndex, columnProp, row) => {
      if (!editingCell.value) return

      const oldValue = row[columnProp]
      const newValue = editingCellValue.value === '' ? null : editingCellValue.value

      if (oldValue !== newValue) {
        // 计算全局索引（考虑分页）
        const globalRowIndex = (currentPage.value - 1) * pageSize.value + rowIndex

        // 保存历史记录
        saveHistory('editCell', {
          rowIndex: globalRowIndex,
          columnProp,
          oldValue
        })
        // 更新单元格值
        row[columnProp] = newValue
        ElMessage({
          message: '修改成功',
          type: 'success',
          duration: 1500
        })
      }

      editingCell.value = null
      editingCellValue.value = ''
    }

    // 取消编辑单元格
    const cancelEditCell = () => {
      editingCell.value = null
      editingCellValue.value = ''
    }

    // 开始编辑列名
    const startEditColumnLabel = (columnProp) => {
      const column = tableColumns.value.find(col => col.prop === columnProp)
      if (column) {
        editingColumnLabel.value = columnProp
        editingLabelValue.value = column.label
      }
    }

    // 保存列名编辑
    const saveColumnLabel = (columnProp) => {
      if (!editingColumnLabel.value) return

      const column = tableColumns.value.find(col => col.prop === columnProp)
      if (column) {
        const oldLabel = column.label
        const newLabel = editingLabelValue.value.trim()

        if (newLabel && oldLabel !== newLabel) {
          // 保存历史记录
          saveHistory('editColumnLabel', {
            prop: columnProp,
            oldLabel
          })
          // 更新列名
          column.label = newLabel
          ElMessage({
            message: '列名修改成功',
            type: 'success',
            duration: 1500
          })
        }
      }

      editingColumnLabel.value = null
      editingLabelValue.value = ''
    }

    // 取消编辑列名
    const cancelEditColumnLabel = () => {
      editingColumnLabel.value = null
      editingLabelValue.value = ''
    }

    // 批量删除
    const batchDelete = () => {
      if (selectedRows.value.length === 0) return

      if (confirm(`确定要删除选中的 ${selectedRows.value.length} 行数据吗？`)) {
        // 保存历史记录（仅保存必要数据）
        saveHistory('batchDelete', JSON.parse(JSON.stringify(chartData.value)))

        // 使用WeakSet优化查找性能
        const toDeleteSet = new WeakSet(selectedRows.value)
        chartData.value = chartData.value.filter(row => !toDeleteSet.has(row))

        // 清空选中状态
        selectedRows.value = []
        ElMessage({
          message: '删除成功',
          type: 'success',
          duration: 2000
        })
      }
    }

    // 切换图表展示面板
    const toggleGraphPanel = () => {
      isGraphPanelOpen.value = !isGraphPanelOpen.value
    }

    // 创建图表
    const createChart = async () => {
      // 验证选择
      if (chartData.value.length === 0) {
        ElMessage({
          message: '请先加载数据',
          type: 'warning',
          duration: 2000
        })
        return
      }

      // 验证数据列选择
      if (selectedYColumns.value.length === 0) {
        ElMessage({
          message: chartType.value === 'pie' ? '请选择类别列' : '请选择数据列',
          type: 'warning',
          duration: 2000
        })
        return
      }

      // 需要X轴的图表类型
      const needXAxisTypes = ['line', 'bar', 'scatter', 'area']
      if (needXAxisTypes.includes(chartType.value) && !xAxisColumn.value) {
        ElMessage({
          message: '请选择X轴列',
          type: 'warning',
          duration: 2000
        })
        return
      }

      // 如果没有选中行，使用所有数据；否则使用选中的数据行
      const data = selectedRows.value.length > 0 ? selectedRows.value : chartData.value

      // 创建图表配置（支持多Y轴列）
      const chartConfig = {
        id: ++chartIdCounter,
        type: chartType.value,
        xAxis: xAxisColumn.value,
        yAxis: selectedYColumns.value[0], // 兼容旧代码
        yColumns: selectedYColumns.value, // 多列数据
        title: selectedYColumns.value.join(', ') + (xAxisColumn.value ? ' - ' + xAxisColumn.value : ''),
        data: {
          x: needXAxisTypes.includes(chartType.value) ? data.map(row => row[xAxisColumn.value]) : null,
          y: selectedYColumns.value.map(col => data.map(row => row[col])),
          labels: chartType.value === 'pie' ? data.map(row => row[selectedYColumns.value[0]]) : null
        }
      }

      // 添加到图表列表
      chartList.value.push(chartConfig)

      // 等待DOM更新后渲染图表
      await nextTick()
      renderChart(chartConfig)

      ElMessage({
        message: '图表创建成功',
        type: 'success',
        duration: 2000
      })
    }

    // 颜色数组
    const chartColors = [
      'rgba(59, 130, 246, 1)',   // blue
      'rgba(16, 185, 129, 1)',   // green
      'rgba(245, 158, 11, 1)',   // orange
      'rgba(239, 68, 68, 1)',    // red
      'rgba(139, 92, 246, 1)',   // purple
      'rgba(236, 72, 153, 1)',   // pink
      'rgba(6, 182, 212, 1)',    // cyan
      'rgba(249, 115, 22, 1)'    // amber
    ]

    // 渲染图表
    const renderChart = (chartConfig) => {
      const container = document.getElementById(`chart-${chartConfig.id}`)
      if (!container) return

      let traces = []
      let layout = {}

      // 获取Y轴列列表（支持多列）
      const yColumns = chartConfig.yColumns || [chartConfig.yAxis]

      // 根据图表类型创建不同的trace和layout
      switch (chartConfig.type) {
        case 'pie':
          // 饼图 - 统计每个类别的数量
          const labelCounts = {}
          chartConfig.data.labels.forEach(label => {
            labelCounts[label] = (labelCounts[label] || 0) + 1
          })
          traces.push({
            labels: Object.keys(labelCounts),
            values: Object.values(labelCounts),
            type: 'pie',
            textinfo: 'label+percent',
            insidetextorientation: 'radial',
            marker: {
              colors: chartColors.map(c => c.replace('1)', '0.8)'))
            }
          })
          layout = {
            margin: { l: 20, r: 20, t: 20, b: 20 },
            height: 200,
            font: { color: '#ccc' },
            paper_bgcolor: 'rgba(0,0,0,0)',
            showlegend: true
          }
          break

        case 'area':
          // 面积图支持多列
          yColumns.forEach((col, index) => {
            traces.push({
              x: chartConfig.data.x,
              y: chartConfig.data.y[index],
              type: 'scatter',
              mode: 'lines',
              fill: index === 0 ? 'tozeroy' : 'tonexty',
              name: col,
              marker: {
                color: chartColors[index % chartColors.length].replace('1)', '0.6)')
              },
              line: {
                color: chartColors[index % chartColors.length],
                width: 2
              }
            })
          })
          layout = {
            xaxis: {
              title: { text: chartConfig.xAxis, font: { size: 12, color: '#aaa' } },
              tickangle: -45,
              tickfont: { size: 11, color: '#ccc' }
            },
            yaxis: {
              title: { text: '数值', font: { size: 12, color: '#aaa' } },
              tickfont: { size: 11, color: '#ccc' }
            },
            margin: { l: 60, r: 20, t: 20, b: 60 },
            height: 200,
            font: { color: '#ccc' },
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            showlegend: true
          }
          break

        case 'histogram':
          // 直方图支持多列
          yColumns.forEach((col, index) => {
            traces.push({
              x: chartConfig.data.y[index],
              type: 'histogram',
              name: col,
              opacity: 0.7,
              marker: {
                color: chartColors[index % chartColors.length].replace('1)', '0.7)'),
                line: { color: chartColors[index % chartColors.length], width: 1 }
              }
            })
          })
          layout = {
            xaxis: {
              title: { text: '数值', font: { size: 12, color: '#aaa' } },
              tickfont: { size: 11, color: '#ccc' }
            },
            yaxis: {
              title: { text: '频数', font: { size: 12, color: '#aaa' } },
              tickfont: { size: 11, color: '#ccc' }
            },
            margin: { l: 60, r: 20, t: 20, b: 60 },
            height: 200,
            font: { color: '#ccc' },
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            showlegend: true,
            barmode: 'overlay'
          }
          break

        case 'box':
          // 箱线图支持多列
          yColumns.forEach((col, index) => {
            traces.push({
              y: chartConfig.data.y[index],
              type: 'box',
              name: col,
              marker: {
                color: chartColors[index % chartColors.length].replace('1)', '0.7)')
              },
              line: {
                color: chartColors[index % chartColors.length]
              },
              boxpoints: 'outliers'
            })
          })
          layout = {
            yaxis: {
              title: { text: '数值', font: { size: 12, color: '#aaa' } },
              tickfont: { size: 11, color: '#ccc' }
            },
            margin: { l: 40, r: 40, t: 20, b: 60 },
            height: 200,
            font: { color: '#ccc' },
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            showlegend: true,
            boxmode: 'group'
          }
          break

        case 'bar':
        default:
          // 柱状图、曲线图、散点图支持多列
          const traceType = chartConfig.type === 'bar' ? 'bar' : 'scatter'
          yColumns.forEach((col, index) => {
            traces.push({
              x: chartConfig.data.x,
              y: chartConfig.data.y[index],
              type: traceType,
              mode: chartConfig.type === 'line' ? 'lines+markers' : (chartConfig.type === 'scatter' ? 'markers' : undefined),
              name: col,
              marker: {
                size: 8,
                color: chartColors[index % chartColors.length]
              },
              line: chartConfig.type === 'line' ? {
                color: chartColors[index % chartColors.length],
                width: 2
              } : undefined
            })
          })
          layout = {
            xaxis: {
              title: { text: chartConfig.xAxis, font: { size: 12, color: '#aaa' } },
              tickangle: -45,
              tickfont: { size: 11, color: '#ccc' }
            },
            yaxis: {
              title: { text: '数值', font: { size: 12, color: '#aaa' } },
              tickfont: { size: 11, color: '#ccc' }
            },
            margin: { l: 60, r: 20, t: 20, b: 60 },
            height: 200,
            font: { color: '#ccc' },
            paper_bgcolor: 'rgba(0,0,0,0)',
            plot_bgcolor: 'rgba(0,0,0,0)',
            showlegend: true,
            barmode: chartConfig.type === 'bar' ? 'group' : undefined
          }
          break
      }

      Plotly.newPlot(container, traces, layout, { responsive: true })
    }

    // 删除图表
    const deleteChart = (chartId) => {
      const container = document.getElementById(`chart-${chartId}`)
      if (container) {
        Plotly.purge(container)
      }
      chartList.value = chartList.value.filter(chart => chart.id !== chartId)
      ElMessage({
        message: '图表已删除',
        type: 'success',
        duration: 2000
      })
    }

    return {
      messages,
      inputMessage,
      isLoading,
      sessions,
      databases,
      showNewChatModal,
      showDeleteConfirmModal,
      showDeleteMessageModal,
      selectedDatabase,
      currentChatTitle,
      selectedSession,
      sessionToDelete,
      messageToDelete,
      isSidebarOpen,
      isSidebarCollapsed,
      sessionsByDatabase,
      createNewChat,
      openNewChatModal,
      selectChat,
      sendMessage,
      regenerateResponse,
      deleteSession,
      confirmDeleteSession,
      deleteMessage,
      confirmDeleteMessage,
      toggleSidebar,
      toggleSidebarCollapse,
      closeSidebarOnMobile,
      activeView,
      toggleView,
      goToChartView,
      marked,
      // 图谱管理相关
      showGraphManagementModal,
      showAdminPasswordModal,
      adminPassword,
      passwordError,
      verifyAdminPassword,
      graphsList,
      databasesList,
      isLoadingGraphs,
      confirmDeleteGraph,
      deleteGraph,
      createGraph,
      getGraphMapping,
      creatingDatabases,
      // 图表区相关
      chartData,
      tableColumns,
      selectedRows,
      chartTitle,
      loadChartData,
      handleSelectionChange,
      deleteColumn,
      tableRef,
      batchDelete,
      tableHeight,
      paginatedChartData,
      // 分页相关
      currentPage,
      totalPages,
      goToPage,
      prevPage,
      nextPage,
      getPageNumbers,
      // 编辑相关
      editingCell,
      editingCellValue,
      editingColumnLabel,
      editingLabelValue,
      startEditCell,
      saveCell,
      cancelEditCell,
      startEditColumnLabel,
      saveColumnLabel,
      cancelEditColumnLabel,
      // 撤销相关
      history,
      undoAction,
      // 图表展示面板相关
      isGraphPanelOpen,
      toggleGraphPanel,
      // 图表配置相关
      chartType,
      xAxisColumn,
      yAxisColumn,
      selectedYColumns,
      showColumnSelector,
      transferColumns,
      confirmColumnSelection,
      chartList,
      createChart,
      deleteChart
    }
  }
}
</script>

<style scoped>
/* 调整表格排序图标位置到列名右侧 */

:deep(.el-table__header-wrapper .el-table__header th) {
  position: relative;
}

:deep(.el-table__header-wrapper .el-table__header th .cell) {
  display: flex;
  align-items: center;
  min-width: 0;
  padding-right: 30px; /* 为删除按钮预留空间 */
}

:deep(.el-table__header-wrapper .el-table__header th .cell .column-header) {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

:deep(.el-table__header-wrapper .el-table__header th .cell .column-header span) {
  flex: 1;
  min-width: 5px; /* 列名可以被压缩 */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

:deep(.el-table__header-wrapper .el-table__header th .cell .el-table__sort-icon) {
  margin-left: 8px;
  flex-shrink: 0; /* 排序图标不压缩 */
  min-width: 20px; /* 确保排序图标有足够空间 */
}

/* 自定义删除列按钮样式，只显示垃圾桶图标 */
.delete-column-btn {
  position: absolute;
  right: 4px;
  top: 50%;
  transform: translateY(-50%);
  background: none !important;
  border: none !important;
  color: #e74c3c !important;
  padding: 0 !important;
  flex-shrink: 0;
  box-shadow: none !important;
  outline: none !important;
}

.delete-column-btn:hover {
  background: none !important;
  box-shadow: none !important;
  color: #c0392b !important;
  outline: none !important;
}

.delete-column-btn:focus {
  background: none !important;
  box-shadow: none !important;
  outline: none !important;
}

.delete-column-btn:active {
  background: none !important;
  box-shadow: none !important;
  outline: none !important;
  color: #c0392b !important;
}

/* 图表展示面板切换按钮 */
.graph-panel-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 8px 16px;
  background-color: #3a3a3a;
  color: #fff;
  cursor: pointer;
  border-radius: 4px 4px 0 0;
  transition: background-color 0.3s;
  user-select: none;
}

.graph-panel-toggle:hover {
  background-color: #4a4a4a;
}

.toggle-icon {
  font-size: 14px;
  transition: transform 0.3s;
}

.toggle-text {
  font-size: 14px;
}

/* 图表展示面板 */
.graph-panel {
  height: 0;
  overflow: hidden;
  transition: height 0.3s ease;
  background-color: #1a1a1a;
  border-top: 1px solid #3a3a3a;
}

.graph-panel-expanded {
  height: 250px;
}

.graph-container {
  height: 100%;
  padding: 16px;
}

.graph-placeholder {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #2a2a2a;
  border-radius: 8px;
}

.graph-title {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 16px;
  color: #fff;
}

.graph-content {
  text-align: center;
  color: #888;
}

.graph-content p {
  margin: 8px 0;
}

/* 表格容器收缩状态 */
.table-container {
  flex: 1;
  overflow: auto;
  transition: flex 0.3s ease;
}

.table-container-shrinked {
  flex: 0.6;
}

/* 表格单元格内容不换行，超出部分隐藏 */
:deep(.el-table__body-wrapper .el-table__row .el-table__cell .cell) {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 调整表格选择列的勾选框位置，使其居中 */
:deep(.el-table__column--selection .cell) {
  display: flex;
  justify-content: center;
  align-items: center;
}

.chart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 20px;
  background-color: white;
  border-top: none;
  border-radius: 0 0 8px 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  min-height: 40px;
}

.footer-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.batch-delete-btn {
  padding: 6px 12px;
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  transition: background-color 0.3s;
  height: 28px;
  line-height: 1;
}

.batch-delete-btn:hover:not(:disabled) {
  background-color: #c0392b;
}

.batch-delete-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

/* 撤销按钮样式 */
.undo-btn {
  padding: 6px 12px;
  background-color: #e67e22;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  transition: background-color 0.3s;
  height: 28px;
  line-height: 1;
  margin-right: 10px;
}

.undo-btn:hover:not(:disabled) {
  background-color: #d35400;
}

.undo-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

/* 单元格编辑输入框 */
.cell-input {
  width: 100%;
  padding: 4px 6px;
  border: 1px solid #3498db;
  border-radius: 3px;
  font-size: 13px;
  outline: none;
  box-sizing: border-box;
  background-color: #fff;
}

.cell-input:focus {
  border-color: #2980b9;
  box-shadow: 0 0 3px rgba(52, 152, 219, 0.3);
}

/* 单元格内容 */
.cell-content {
  min-height: 24px;
  padding: 4px 6px;
}

.cell-content:hover {
  background-color: #f5f7fa;
}

/* 列名编辑输入框 */
.column-label-input {
  flex: 1;
  padding: 4px 6px;
  border: 1px solid #3498db;
  border-radius: 3px;
  font-size: 13px;
  outline: none;
  background-color: #fff;
  min-width: 50px;
}

.column-label-input:focus {
  border-color: #2980b9;
  box-shadow: 0 0 3px rgba(52, 152, 219, 0.3);
}

/* 列名可点击样式 */
.column-header > div {
  cursor: pointer;
  flex: 1;
  min-width: 5px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.column-header > div:hover span {
  color: #3498db;
  text-decoration: underline;
}

/* 单元格可双击编辑样式 */
:deep(.el-table__body-wrapper .el-table__row .el-table__cell .cell > div) {
  cursor: pointer;
}

:deep(.el-table__body-wrapper .el-table__row .el-table__cell .cell > div:hover) {
  background-color: rgba(52, 152, 219, 0.1);
}

.chat-container {
  display: flex;
  height: 100vh;
  width: 100vw;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}

/* 侧边栏 */
.sidebar {
  width: 300px;
  background-color: #2c3e50;
  color: white;
  display: flex;
  flex-direction: column;
  padding: 15px;
  box-sizing: border-box;
  overflow: hidden;
}

.sidebar-header {
  margin-bottom: 20px;
}

.sidebar-footer {
  margin-top: auto;
}

.database-header {
  padding: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 14px;
  font-weight: bold;
  color: #20ff63;
}



.graph-management-btn {
  width: 100%;
  padding: 10px;
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s;
}

.graph-management-btn:hover {
  background-color: #c0392b;
}

.graph-management-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.graph-management-btn:disabled:hover {
  background-color: #bdc3c7;
}

.sidebar-header h2 {
  margin: 0 0 15px 0;
  font-size: 24px;
}

.new-chat-btn {
  width: 100%;
  padding: 10px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s;
}

.new-chat-btn:hover {
  background-color: #2980b9;
}

.new-chat-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.new-chat-btn:disabled:hover {
  background-color: #bdc3c7;
}

.sessions-list {
  flex: 1;
  margin-bottom: 15px;
  max-height: calc(100vh - 210px);
  display: flex;
  flex-direction: column;
}

.sessions-container {
  flex: 1;
  overflow-y: auto;
  padding-right: 8px;
}

.sessions-list h3 {
  margin: 0 0 12px 0;
  font-size: 18px;
  color: #bdc3c7;
  z-index: 1;
}

.session-item {
  position: relative;
  padding: 12px;
  margin-bottom: 8px;
  background-color: #34495e;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.session-item:hover {
  background-color: #4a647f;
}

/* 滚动条样式 */
.sessions-container::-webkit-scrollbar {
  width: 8px;
}

.sessions-container::-webkit-scrollbar-track {
  background: #2c3e50;
  border-radius: 4px;
}

.sessions-container::-webkit-scrollbar-thumb {
  background: #34495e;
  border-radius: 4px;
  border: 2px solid #2c3e50;
}

.sessions-container::-webkit-scrollbar-thumb:hover {
  background: #4a647f;
}

/* 当前选中会话的样式 */
.session-item-selected {
  color: #edef80 !important;
  font-weight: bold;
  font-size: inherit;
}

/* 删除会话按钮 */
.delete-session-btn {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: transparent;
  color: rgba(255, 255, 255, 0.7);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
  opacity: 0;
  margin-left: 8px;
  font-size: 20px;
  font-weight: bold;
  line-height: 1;
  padding: 0;
}

.session-item:hover .delete-session-btn {
  opacity: 1;
}

.delete-session-btn:hover {
  background-color: rgba(231, 76, 60, 0.9);
  color: white;
  opacity: 1;
}

.delete-session-btn:disabled {
  color: rgba(255, 255, 255, 0.3);
  cursor: not-allowed;
  opacity: 0.5;
}

.delete-session-btn:disabled:hover {
  background-color: transparent;
}

/* 删除消息按钮 */
.delete-message-btn {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: transparent;
  color: rgba(231, 76, 60, 0.7);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
  opacity: 0;
  font-size: 20px;
  font-weight: bold;
  line-height: 1;
  padding: 0;
  margin-right: 8px;
}

.message:hover .delete-message-btn {
  opacity: 1;
}

.delete-message-btn:hover {
  background-color: rgba(231, 76, 60, 0.9);
  color: white;
}

.delete-message-btn:disabled {
  color: rgba(231, 76, 60, 0.3);
  cursor: not-allowed;
  opacity: 0.5;
}



.delete-message-btn:disabled:hover {
  background-color: transparent;
}

/* 防止删除按钮影响文本选择 */
.session-item > div {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 聊天主界面 */
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: #ecf0f1;
  overflow-x: hidden;
  width: 100%;
}

.chat-header {
  padding: 20px;
  background-color: white;
  border-bottom: 1px solid #bdc3c7;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-header h3 {
  margin: 0;
  font-size: 20px;
  color: #2c3e50;
}

.view-toggle-buttons {
  display: flex;
  gap: 10px;
}

/* 视图切换按钮 */
.view-toggle-btn {
  padding: 8px 16px;
  background-color: #f0f0f0;
  border: 1px solid #bdc3c7;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  color: #2c3e50;
  transition: all 0.3s;
}

.view-toggle-btn:hover:not(:disabled) {
  background-color: #e0e0e0;
}

.view-toggle-btn.active {
  background-color: #3498db;
  color: white;
  border-color: #3498db;
}

.view-toggle-btn.active:hover:not(:disabled) {
  background-color: #2980b9;
}

.view-toggle-btn:disabled {
  background-color: #f0f0f0;
  color: #bdc3c7;
  border-color: #bdc3c7;
  cursor: not-allowed;
}

.view-toggle-btn.active:disabled {
  background-color: #3498db;
  opacity: 0.6;
  cursor: not-allowed;
}



/* 聊天消息区域 */
.chat-messages {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.message {
  display: flex;
  gap: 10px;
  align-items: flex-start;
}

.user-message {
  justify-content: flex-end;
}

.assistant-message {
  justify-content: flex-start;
  margin-left: 20px;
}

.message-content {
  max-width: 70%;
  padding: 15px;
  border-radius: 12px;
  word-wrap: break-word;
}

.user-message .message-content {
  background-color: #3498db;
  color: white;
  border-bottom-right-radius: 4px;
}

.assistant-message .message-content {
  background-color: white;
  color: #2c3e50;
  border-bottom-left-radius: 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  padding: 1px;
}



.message-text {
  line-height: 1.6;
}

/* Markdown渲染样式 */
.message-text h1, .message-text h2, .message-text h3, .message-text h4, .message-text h5, .message-text h6 {
  margin-top: 1.5em;
  margin-bottom: 0.5em;
  font-weight: bold;
}

.message-text h1 {
  font-size: 1.8em;
}

.message-text h2 {
  font-size: 1.6em;
}

.message-text h3 {
  font-size: 1.4em;
}

.message-text p {
  margin-top: 0;
  margin-bottom: 1em;
}

.message-text ul, .message-text ol {
  margin-top: 0;
  margin-bottom: 1em;
  padding-left: 1.5em;
}

.message-text li {
  margin-bottom: 0.5em;
}

.message-text strong {
  font-weight: bold;
}

.message-text em {
  font-style: italic;
}

.message-text code {
  background-color: rgba(0, 0, 0, 0.05);
  padding: 0.2em 0.4em;
  border-radius: 3px;
  font-family: monospace;
  font-size: 0.9em;
}

.message-text pre {
  background-color: rgba(0, 0, 0, 0.05);
  padding: 1em;
  border-radius: 6px;
  overflow-x: auto;
  margin-bottom: 1em;
}

.message-text pre code {
  background-color: transparent;
  padding: 0;
  font-size: 1em;
}

.message-text blockquote {
  border-left: 3px solid #3498db;
  margin-left: 0;
  padding-left: 1em;
  color: #666;
  font-style: italic;
}

.message-text a {
  color: #3498db;
  text-decoration: underline;
}

.message-text table {
  border-collapse: collapse;
  width: 100%;
  margin-bottom: 1em;
}

.message-text th, .message-text td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.message-text th {
  background-color: #f8f9fa;
  font-weight: bold;
}

.message-reasoning-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background-color: #f8f9fa;
  border-radius: 8px;
  font-size: 14px;
  border-left: 3px solid #3498db;
  cursor: pointer;
  transition: background-color 0.3s;
}

.message-reasoning-header:hover {
  background-color: #e9ecef;
}

.reasoning-toggle {
  font-size: 12px;
  color: #666;
  transition: transform 0.3s;
}

.message-reasoning-content {
  padding: 10px 12px;
  background-color: #f8f9fa;
  border-radius: 0 0 8px 8px;
  font-size: 14px;
  border-left: 3px solid #3498db;
  border-top: 1px solid #e9ecef;
  line-height: 1.6;
  text-align: left;
  color: #666;
  white-space: pre-line;
}

.message-results-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background-color: #f8f9fa;
  border-radius: 8px 8px 0 0;
  font-size: 14px;
  border-left: 3px solid #27ae60;
  cursor: pointer;
  transition: background-color 0.3s;
}

.message-results-header:hover {
  background-color: #e9ecef;
}

.results-toggle {
  font-size: 12px;
  color: #666;
  transition: transform 0.3s;
}

.results-more {
  font-style: italic;
  font-size: 13px;
}

.message-results {
  margin-top: 10px;
  max-width: 100%;
}

.chat-table {
  overflow-x: auto;
  max-width: 100%;
  display: block;
  -webkit-overflow-scrolling: touch;
  border-radius: 0 0 8px 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.chat-table table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  table-layout: auto;
  max-width: 100%;
}

.chat-table th, .chat-table td {
  padding: 8px 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
  white-space: normal;
  word-break: break-word;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
  min-width: 80px;
}

.chat-table th:hover, .chat-table td:hover {
  white-space: normal;
  word-break: break-word;
  position: relative;
  z-index: 1;
  background-color: #f9f9f9;
  max-width: none;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.chat-table th {
  background-color: #f2f2f2;
  font-weight: bold;
  border-bottom: 2px solid #ddd;
}

.message-actions {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-top: 10px;
  gap: 8px;
}

.regenerate-btn {
  padding: 6px 12px;
  background-color: #f0f0f0;
  border: 1px solid #ddd;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  color: #666;
  transition: all 0.3s;
}

.regenerate-btn:hover:not(:disabled) {
  background-color: #e0e0e0;
}

.regenerate-btn:disabled {
  background-color: #f0f0f0;
  color: #bdc3c7;
  cursor: not-allowed;
  border-color: #e0e0e0;
}



/* 确保按钮内容居中对齐 */
.regenerate-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

/* 输入区域 */
.chat-input {
  padding: 20px;
  background-color: white;
  border-top: 1px solid #bdc3c7;
  display: flex;
  gap: 10px;
}

.chat-input input {
  flex: 1;
  padding: 12px 16px;
  border: 1px solid #bdc3c7;
  border-radius: 24px;
  font-size: 16px;
  outline: none;
  transition: border-color 0.3s;
}

.chat-input input:focus {
  border-color: #3498db;
}

.send-btn {
  padding: 12px 24px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 24px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s;
}

.send-btn:hover:not(:disabled) {
  background-color: #2980b9;
}

.send-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

/* 模态框 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  padding: 30px;
  border-radius: 12px;
  width: 400px;
  max-width: 90%;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-content h3 {
  margin: 0 0 20px 0;
  font-size: 20px;
  color: #2c3e50;
}

.modal-body {
  margin-bottom: 20px;
}

.modal-body label {
  display: block;
  margin-bottom: 8px;
  font-weight: bold;
  color: #2c3e50;
}

.database-select {
  width: 100%;
  padding: 10px;
  border: 1px solid #bdc3c7;
  border-radius: 6px;
  font-size: 16px;
  outline: none;
}

.modal-footer {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.cancel-btn, .confirm-btn {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s;
}

.cancel-btn {
  background-color: hsl(251, 78%, 72%);
  color: white;
}

.cancel-btn:hover {
  background-color: #9b59b6;
}

.confirm-btn {
  background-color: #27ae60;
  color: white;
}

.confirm-btn:hover {
  background-color: #229954;
}

.chart-area {
  flex: 1;
  padding: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background-color: #ecf0f1;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #bdc3c7;
}

.chart-header h3 {
  margin: 0;
  font-size: 20px;
  color: #2c3e50;
}

.chart-actions {
  display: flex;
  gap: 10px;
}

.load-data-btn {
  padding: 8px 16px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.load-data-btn:hover:not(:disabled) {
  background-color: #2980b9;
}

.load-data-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.table-container {
  flex: 1;
  overflow: auto;
  background-color: white;
  border-radius: 8px 8px 0 0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  margin-bottom: 0;
  display: flex;
  flex-direction: column;
  border-bottom: 1px solid #bdc3c7;
}

.table-container .el-table {
  flex: 1;
  min-height: 100%;
  display: flex;
  flex-direction: column;
}

.table-container .el-table__body-wrapper {
  flex: 1;
}



.selected-info {
  font-size: 14px;
  color: #666;
}

/* 分页容器 */
.pagination-container {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 分页按钮 */
.pagination-btn {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: #fff;
  color: #666;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.pagination-btn:hover:not(:disabled) {
  border-color: #3498db;
  color: #3498db;
}

.pagination-btn:active:not(:disabled) {
  background-color: #f0f8ff;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-btn-active {
  background-color: #3498db;
  border-color: #3498db;
  color: #fff;
}

.pagination-btn-active:hover {
  background-color: #2980b9;
  border-color: #2980b9;
}

/* 分页省略号 */
.pagination-ellipsis {
  color: #999;
  font-size: 14px;
  padding: 0 4px;
}

/* 删除确认按钮 */
.delete-confirm-btn {
  background-color: #e74c3c;
}

.delete-confirm-btn:hover {
  background-color: #c0392b;
}

/* 图谱管理模态框样式 */
.loading-indicator {
  text-align: center;
  padding: 20px;
  color: #666;
}

.empty-graphs {
  text-align: center;
  padding: 20px;
  color: #666;
}

.graphs-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.graph-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  background-color: #f8f9fa;
  border-radius: 6px;
  border: 1px solid #e9ecef;
}

.graph-info {
  flex: 1;
}

.graph-name {
  display: block;
  font-weight: bold;
  margin-bottom: 4px;
  color: #2c3e50;
}

.graph-mapping {
  display: block;
  font-size: 14px;
  color: #6c757d;
  font-family: monospace;
}

.delete-graph-btn {
  padding: 6px 12px;
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.delete-graph-btn:hover {
  background-color: #c0392b;
}

.delete-graph-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.delete-graph-btn:disabled:hover {
  background-color: #bdc3c7;
}

.create-graph-btn {
  padding: 6px 12px;
  background-color: #27ae60;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.create-graph-btn:hover {
  background-color: #2ecc71;
}

.create-graph-btn:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.create-graph-btn:disabled:hover {
  background-color: #bdc3c7;
}

/* 移动端侧边栏切换按钮 */
.mobile-sidebar-toggle {
  display: none;
  position: fixed;
  top: 20px;
  left: 20px;
  z-index: 1001;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #3498db;
  color: white;
  border: none;
  font-size: 24px;
  cursor: pointer;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  transition: background-color 0.3s;
}

.mobile-sidebar-toggle:hover {
  background-color: #2980b9;
}

/* 桌面端侧边栏切换按钮 */
.desktop-sidebar-toggle {
  position: fixed;
  top: 50%;
  left: 300px;
  transform: translateY(-50%);
  z-index: 999;
  width: 20px;
  height: 60px;
  border-radius: 0 8px 8px 0;
  background-color: #34495e;
  color: white;
  border: none;
  font-size: 10px;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.desktop-sidebar-toggle:hover {
  background-color: #4a647f;
}

.desktop-sidebar-toggle.collapsed {
  left: 0;
  border-radius: 0 8px 8px 0;
}

/* 侧边栏 */
.sidebar {
  width: 300px;
  background-color: #2c3e50;
  color: white;
  display: flex;
  flex-direction: column;
  padding: 20px;
  box-sizing: border-box;
  transition: all 0.3s;
  position: relative;
  z-index: 1000;
}

.sidebar.collapsed {
  width: 0;
  padding: 0;
  overflow: hidden;
}

.sidebar.collapsed .sidebar-header,
.sidebar.collapsed .new-chat-btn,
.sidebar.collapsed .sessions-list {
  display: none;
}

/* 响应式设计 */
@media (max-width: 768px) {
  /* 显示侧边栏切换按钮 */
  .mobile-sidebar-toggle {
    display: flex;
    align-items: center;
    justify-content: center;
  }

  /* 隐藏桌面端侧边栏切换按钮 */
  .desktop-sidebar-toggle {
    display: none;
  }

  /* 侧边栏样式 */
  .sidebar {
    position: fixed;
    left: -300px;
    top: 0;
    height: 100vh;
    z-index: 1000;
    transition: left 0.3s;
    width: 280px;
  }

  .sidebar.open {
    left: 0;
  }

  .sidebar.collapsed {
    width: 280px;
    padding: 20px;
  }

  /* 聊天主区域样式 */
  .chat-main {
    width: 100%;
    overflow-x: hidden;
  }

  /* 消息内容样式 */
  .message-content {
    max-width: 90%;
  }



  /* 输入区域样式 */
  .chat-input {
    padding: 15px;
    flex-direction: column;
    gap: 10px;
  }

  .chat-input input {
    width: calc(100% - 32px);
  }

  .send-btn {
    width: 100%;
  }

  /* 模态框样式 */
  .modal-content {
    width: 90%;
    padding: 20px;
  }

  /* 标题样式 */
  .chat-header h3 {
    font-size: 16px;

  }

  /* 视图切换按钮容器 */
  .view-toggle-buttons {
    gap: 5px;
  }

  /* 视图切换按钮 */
  .view-toggle-btn {
    padding: 6px 12px;
    font-size: 12px;
  }

  /* 消息区域内边距 */
  .chat-messages {
    padding: 15px;
  }


}

/* 小屏幕设备优化 */
@media (max-width: 480px) {
  .sidebar {
    width: 100%;
    left: -100%;
  }

  .message-content {
    max-width: 95%;
  }

  .chat-input {
    padding: 10px;
  }

  .chat-messages {
    padding: 10px;

  }
}

/* 图表配置面板样式 */
.chart-config-panel {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px 20px;
  background-color: #2a2a2a;
  border-bottom: 1px solid #3a3a3a;
  flex-wrap: wrap;
}

.config-group {
  display: flex;
  align-items: center;
  gap: 8px;
}

.config-label {
  color: #fff;
  font-size: 14px;
}

.config-select {
  padding: 6px 12px;
  border-radius: 4px;
  border: 1px solid #4a4a4a;
  background-color: #1a1a1a;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
  min-width: 120px;
}

.config-select:focus {
  outline: none;
  border-color: #3b82f6;
}

.config-select option {
  background-color: #1a1a1a;
  color: #fff;
}

.config-group-hidden {
  display: none;
}

.multi-select-wrapper {
  position: relative;
}

.multi-select-input {
  padding: 6px 12px;
  border-radius: 4px;
  border: 1px solid #4a4a4a;
  background-color: #1a1a1a;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
  min-width: 150px;
  max-width: 250px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.multi-select-input:hover {
  border-color: #3b82f6;
}

.multi-select-input:focus {
  outline: none;
  border-color: #3b82f6;
}

.create-chart-btn {
  padding: 6px 16px;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.create-chart-btn:hover:not(:disabled) {
  background-color: #2563eb;
}

.create-chart-btn:disabled {
  background-color: #6b7280;
  cursor: not-allowed;
}

/* 图表滚动容器 */
.charts-scroll-container {
  height: 100%;
  overflow: hidden;
}

.charts-container {
  display: flex;
  gap: 16px;
  padding: 16px;
  overflow-x: auto;
  overflow-y: hidden;
  height: calc(100% - 32px);
}

.charts-container::-webkit-scrollbar {
  height: 8px;
}

.charts-container::-webkit-scrollbar-track {
  background: #2a2a2a;
  border-radius: 4px;
}

.charts-container::-webkit-scrollbar-thumb {
  background: #4a4a4a;
  border-radius: 4px;
}

.charts-container::-webkit-scrollbar-thumb:hover {
  background: #5a5a5a;
}

/* 单个图表项 */
.chart-item {
  flex: 0 0 auto;
  width: 400px;
  background-color: #2a2a2a;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.chart-header-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  background-color: #1a1a1a;
  border-bottom: 1px solid #3a3a3a;
}

.chart-title {
  font-size: 14px;
  font-weight: 500;
  color: #fff;
}

.delete-chart-btn {
  background: none;
  border: none;
  color: #e74c3c;
  font-size: 18px;
  cursor: pointer;
  padding: 0 8px;
  transition: color 0.3s;
  line-height: 1;
}

.delete-chart-btn:hover {
  color: #c0392b;
}

.chart-content {
  padding: 8px;
  height: 200px;
}

/* 图表展示面板扩展状态 */
.graph-panel-expanded {
  height: 280px;
}

/* 列选择器弹窗样式 */
.column-selector-modal {
  width: 700px;
  max-width: 90vw;
  background-color: #3a3a3a;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
}

.column-selector-modal .modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background-color: #2d2d2d;
  border-bottom: 1px solid #4a4a4a;
}

.column-selector-modal .modal-header h3 {
  margin: 0;
  color: #fff;
  font-size: 16px;
}

.column-selector-modal .modal-close {
  background: none;
  border: none;
  color: #aaa;
  font-size: 20px;
  cursor: pointer;
  padding: 0 8px;
}

.column-selector-modal .modal-close:hover {
  color: #fff;
}

.column-selector-modal .modal-body {
  padding: 16px;
}

/* 穿梭框容器，确保左右排列 */
.transfer-wrapper {
  width: 100%;
}

.column-selector-modal .modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 20px;
  background-color: #2d2d2d;
  border-top: 1px solid #4a4a4a;
}

.column-selector-modal .cancel-btn,
.column-selector-modal .confirm-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.column-selector-modal .cancel-btn {
  background-color: #5a5a5a;
  color: #fff;
}

.column-selector-modal .cancel-btn:hover {
  background-color: #6a6a6a;
}

.column-selector-modal .confirm-btn {
  background-color: #3b82f6;
  color: #fff;
}

.column-selector-modal .confirm-btn:hover {
  background-color: #2563eb;
}

/* Element Plus Transfer 组件样式覆盖 - 更亮的颜色 */
:deep(.el-transfer) {
  display: flex;
  flex-direction: row;
  width: 100%;
}

:deep(.el-transfer-panel) {
  background-color: #2d2d2d;
  border-color: #4a4a4a;
  flex: 1;
}

:deep(.el-transfer-panel:first-child) {
  margin-right: 8px;
}

:deep(.el-transfer-panel__header) {
  background-color: #3a3a3a;
  border-bottom-color: #4a4a4a;
  color: #fff;
}

:deep(.el-transfer-panel__header .el-checkbox) {
  color: #fff;
}

:deep(.el-transfer-panel__body) {
  background-color: #2d2d2d;
}

:deep(.el-transfer-panel__list) {
  background-color: #2d2d2d;
}

:deep(.el-transfer-panel__item) {
  color: #e0e0e0;
  background-color: transparent;
}

:deep(.el-transfer-panel__item:hover) {
  background-color: #4a4a4a;
}

:deep(.el-transfer-panel__item.is-checked) {
  background-color: rgba(59, 130, 246, 0.3);
  color: #60a5fa;
}

:deep(.el-transfer__button) {
  display: flex;
  flex-direction: column;
  justify-content: center;
  background-color: #3b82f6;
  border-color: #3b82f6;
  margin: 4px 8px;
  padding: 6px 8px;
  gap: 8px;
}

:deep(.el-transfer__button:first-child) {
  margin-bottom: 8px;
}

:deep(.el-transfer__button:hover) {
  background-color: #2563eb;
  border-color: #2563eb;
}

:deep(.el-transfer__filter) {
  background-color: #2d2d2d;
  border-color: #4a4a4a;
  color: #f0f0f0;
}

:deep(.el-transfer__filter::placeholder) {
  color: #888;
}

:deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
  background-color: #3b82f6;
  border-color: #3b82f6;
}

:deep(.el-checkbox__input.is-indeterminate .el-checkbox__inner) {
  background-color: #3b82f6;
  border-color: #3b82f6;
}

/* 按钮图标颜色 */
:deep(.el-transfer__button .el-icon) {
  color: #fff;
}

/* 选中项文字颜色 */
:deep(.el-transfer-panel__item.is-checked) {
  color: #7dd3fc;
}

/* 穿梭框标题文字颜色 */
:deep(.el-transfer-panel__header .el-transfer-panel__title) {
  color: #f0f0f0;
}
</style>